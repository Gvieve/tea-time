require 'rails_helper'

describe 'User subscriptions request' do
  describe 'happy path' do
    before :all do
      @user = create(:user)
      plan = create(:plan, weekly_frequency: 4)
      @teas = create_list(:tea, 3)
    end
    it "creates a user subscription and tea subscriptions when given valid data" do
      params = {
        name: "My Monthly Tea Fix",
        process_on_date: "2021-07-01",
        weekly_frequency: 4,
        teas: [ {tea_id: @teas.first.id, quantity: 1},
                {tea_id: @teas.second.id, quantity: 2} ]
              }
      header = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

      post "/api/v1/users/#{@user.id}/subscriptions", headers: header, params: params.to_json

      json = JSON.parse(response.body, symbolize_names:true)

      expect(response).to be_successful
      expect(json).to be_a(Hash)
      expect(json[:data]).to be_a(Hash)
      check_hash_structure(json[:data], :id, String)
      check_hash_structure(json[:data], :type, String)
      expect(json[:data][:type]).to eq("user_subscription")
      expect(json[:data][:attributes]).to be_a(Hash)
      check_hash_structure(json[:data][:attributes], :user_id, Integer)
      check_hash_structure(json[:data][:attributes], :name, String)
      check_hash_structure(json[:data][:attributes], :process_on_date, String)
      check_hash_structure(json[:data][:attributes], :weekly_frequency, String)
      check_hash_structure(json[:data][:attributes], :status, String)
      check_hash_structure(json[:data][:attributes], :teas, Array)
      expect(json[:data][:attributes][:teas].count).to eq(2)
      expect(json[:data][:attributes][:teas].first).to be_a(Hash)

      tea = json[:data][:attributes][:teas].first

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
