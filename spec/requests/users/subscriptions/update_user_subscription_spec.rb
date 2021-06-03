require 'rails_helper'

describe 'User subscriptions request' do
  describe 'happy path' do
    before :all do
      @user = create(:user)
      @plan_4 = create(:plan, weekly_frequency: 4)
      @plan_6 = create(:plan, weekly_frequency: 6)
      # @teas = create_list(:tea, 3)
      @subscription = create(:subscription, user: @user, plan: @plan_4)
      @tea_subscriptions = create_list(:tea_subscription, 3, subscription: @subscription, quantity: 2, status: 'active')
    end

    it "updates a user subscription and tea subscriptions when given valid data" do
      previous_process_date = @subscription.process_on_date
      previous_name = @subscription.name
      previous_active_teas = TeaSubscription.where(subscription_id: @subscription.id).where(status: :active)

      expect(@subscription.tea_subscriptions.count).to eq(3)
      expect(@subscription.tea_subscriptions.first.quantity).to eq(2)
      expect(@subscription.tea_subscriptions.second.quantity).to eq(2)
      expect(@subscription.tea_subscriptions.third.quantity).to eq(2)
      expect(@subscription.plan_id).to eq(@plan_4.id)
      expect(previous_active_teas.count).to eq(3)

      params = {
        status: 'active',
        name: "My Tea Fix",
        process_on_date: "2021-07-01",
        weekly_frequency: 6,
        teas: [ {tea_id: @subscription.teas.first.id, quantity: 3, status: 'active'},
                {tea_id: @subscription.teas.third.id, quantity: 2, status: 'cancelled'} ]
              }
      header = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

      patch "/api/v1/users/#{@user.id}/subscriptions/#{@subscription.id}", headers: header, params: params.to_json

      json = JSON.parse(response.body, symbolize_names:true)

      expect(response).to be_successful
      expect(json).to be_a(Hash)
      expect(json[:data]).to be_a(Hash)
      check_hash_structure(json[:data], :id, String)
      check_hash_structure(json[:data], :type, String)
      expect(json[:data][:type]).to eq("user_subscription")
      expect(json[:data][:attributes]).to be_a(Hash)

      active_teas = TeaSubscription.where(subscription_id: @subscription.id).where(status: :active)
      @subscription.reload

      expect(@subscription.tea_subscriptions.count).to eq(3)
      expect(@subscription.tea_subscriptions.first.quantity).to eq(3)
      expect(@subscription.tea_subscriptions.second.quantity).to eq(2)
      expect(@subscription.tea_subscriptions.third.status).to eq('cancelled')
      expect(@subscription.plan_id).to eq(@plan_6.id)
      expect(active_teas.count).to eq(2)

      expect(json[:data][:attributes][:teas].count).to eq(3)
      expect(json[:data][:attributes][:teas].first).to be_a(Hash)
    end
  end

  describe 'sad path/edge cases' do
    describe 'returns an error' do
      before :all do
        @user = create(:user)
        plan = create(:plan, weekly_frequency: 4)
        @teas = create_list(:tea, 3)
      end
      it "does not create a subscription when the user id is invalid" do
        params = {
          name: "My Monthly Tea Fix",
          process_on_date: "2021-07-01",
          weekly_frequency: 4,
          teas: [ {tea_id: @teas.first.id, quantity: 1},
                  {tea_id: @teas.second.id, quantity: 2} ]
                }
        header = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
        id = 12345678
        post "/api/v1/users/#{id}/subscriptions", headers: header, params: params.to_json

        expect(response).to_not be_successful
        json = JSON.parse(response.body, symbolize_names:true)

        expect(response.status).to eq(404)
        expect(json[:error]).to be_a(String)
        expect(json[:error]).to eq("Couldn't find User with 'id'=#{id}")
      end

      it "does not create a subscription when required parameters are missing" do
        params = {
          name: "My Monthly Tea Fix",
          weekly_frequency: 4,
          teas: [ {tea_id: @teas.first.id, quantity: 1},
                  {tea_id: @teas.second.id, quantity: 2} ]
                }
        header = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

        post "/api/v1/users/#{@user.id}/subscriptions", headers: header, params: params.to_json

        expect(response).to_not be_successful
        json = JSON.parse(response.body, symbolize_names:true)

        expect(response.status).to eq(400)
        expect(json[:error]).to be_a(String)
        expect(json[:error]).to eq("Required parameter missing")
        expect(json[:url]).to be_a(String)
      end
    end
  end
end
