require 'rails_helper'

describe 'User subscriptions request' do
  describe 'happy path' do
    before :each do
      @user = create(:user)
      @plan_4 = create(:plan, weekly_frequency: 4)
      @plan_6 = create(:plan, weekly_frequency: 6)
      @subscription_1 = create(:subscription, user: @user, plan: @plan_4)
      @tea_subscriptions = create_list(:tea_subscription, 3, subscription: @subscription_1, quantity: 2, status: 'active')
      @subscription_2 = create(:subscription, user: @user, plan: @plan_6, status: 'cancelled')
      @tea_subscriptions_2 = create_list(:tea_subscription, 2, subscription: @subscription_2, quantity: 2, status: 'cancelled')
      @subscription_3 = create(:subscription, user: @user, plan: @plan_6, status: 'active')
      @tea_subscriptions_3 = create_list(:tea_subscription, 2, subscription: @subscription_3, quantity: 2, status: 'active')
    end
    it "creates a user subscription and tea subscriptions when given valid data" do
      header = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

      get "/api/v1/users/#{@user.id}/subscriptions", headers: header

      json = JSON.parse(response.body, symbolize_names:true)

      expect(response).to be_successful
      expect(json).to be_a(Hash)
      expect(json[:data]).to be_a(Hash)
      check_hash_structure(json[:data], :id, String)
      check_hash_structure(json[:data], :type, String)
      expect(json[:data][:type]).to eq("user_subscriptions")
      expect(json[:data][:attributes]).to be_a(Hash)
      check_hash_structure(json[:data][:attributes], :subscriptions, Array)
      expect(json[:data][:attributes][:subscriptions].count).to eq(3)

      subscription = json[:data][:attributes][:subscriptions].first
      check_hash_structure(subscription, :user_id, Integer)
      check_hash_structure(subscription, :name, String)
      check_hash_structure(subscription, :process_on_date, String)
      check_hash_structure(subscription, :weekly_frequency, String)
      check_hash_structure(subscription, :status, String)
      check_hash_structure(subscription, :teas, Array)
      expect(subscription[:teas].first).to be_a(Hash)
      expect(subscription[:teas].count).to eq(3)

      tea = subscription[:teas].first

      check_hash_structure(tea, :tea_id, Integer)
      check_hash_structure(tea, :title, String)
      check_hash_structure(tea, :box_count, Integer)
      check_hash_structure(tea, :quantity, Integer)
      check_hash_structure(tea, :unit_price, String)
      check_hash_structure(tea, :total_price, String)
    end
  end

  describe 'sad path/edge cases' do
    describe 'returns an error' do
      before :each do
        @user = create(:user)
        @plan_4 = create(:plan, weekly_frequency: 4)
        @plan_6 = create(:plan, weekly_frequency: 6)
        @subscription_1 = create(:subscription, user: @user, plan: @plan_4)
        @tea_subscriptions = create_list(:tea_subscription, 3, subscription: @subscription_1, quantity: 2, status: 'active')
        @subscription_2 = create(:subscription, user: @user, plan: @plan_6, status: 'cancelled')
        @tea_subscriptions_2 = create_list(:tea_subscription, 2, subscription: @subscription_2, quantity: 2, status: 'cancelled')
        @subscription_3 = create(:subscription, user: @user, plan: @plan_6, status: 'active')
        @tea_subscriptions_3 = create_list(:tea_subscription, 2, subscription: @subscription_3, quantity: 2, status: 'active')
      end
      it "when the user id is invalid" do
        header = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
        id = 12345678
        get "/api/v1/users/#{id}/subscriptions", headers: header

        expect(response).to_not be_successful
        json = JSON.parse(response.body, symbolize_names:true)

        expect(response.status).to eq(404)
        expect(json[:error]).to be_a(String)
        expect(json[:error]).to eq("Couldn't find User with 'id'=#{id}")
      end

      it "when the user id is not an integer" do
        header = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
        id = "puppies"
        get "/api/v1/users/#{id}/subscriptions", headers: header

        expect(response).to_not be_successful
        json = JSON.parse(response.body, symbolize_names:true)

        expect(response.status).to eq(400)
        expect(json[:error]).to be_a(String)
        expect(json[:error]).to eq("String not accepted as id")
      end
    end
  end
end
