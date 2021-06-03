require 'rails_helper'

describe 'User subscriptions request' do
  describe 'happy path' do
    before :all do
      @user = create(:user)
      plan = create(:plan, weekly_frequency: 4)
      @teas = create_list(:tea, 3)
      # user_profile = create(:user_profile, user: @user)
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
    end
  end
end
