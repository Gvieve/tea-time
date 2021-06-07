require 'rails_helper'

describe 'User tea subscriptions search request' do
  describe 'happy path' do
    before :each do
      @user = create(:user)
      @plan_4 = create(:plan, weekly_frequency: 4)
      @plan_6 = create(:plan, weekly_frequency: 6)
      @subscription = create(:subscription, user: @user, plan: @plan_4)
      @subscription_2 = create(:subscription, user: @user, plan: @plan_6)
      @tea_1 = create(:tea, temperature: 195, brew_time: 7, title: "B Tea")
      @tea_2 = create(:tea, temperature: 202, brew_time: 4, title: "C Tea")
      @tea_3 = create(:tea, temperature: 190, brew_time: 5, title: "E Tea")
      @tea_4 = create(:tea, temperature: 175, brew_time: 10, title: "D Tea")
      @tea_5 = create(:tea, temperature: 212, brew_time: 6, title: "A Tea")
      @tea_subscription_1 = create(:tea_subscription, tea: @tea_1, subscription: @subscription, quantity: 1, status: 'active')
      @tea_subscription_2 = create(:tea_subscription, tea: @tea_2, subscription: @subscription, quantity: 2, status: 'active')
      @tea_subscription_3 = create(:tea_subscription, tea: @tea_3, subscription: @subscription_2, quantity: 3, status: 'active')
      @tea_subscription_4 = create(:tea_subscription, tea: @tea_4, subscription: @subscription, quantity: 2, status: 'active')
      @tea_subscription_5 = create(:tea_subscription, tea: @tea_5, subscription: @subscription, quantity: 1, status: 'active')
      @tea_subscription_6 = create(:tea_subscription, tea: @tea_1, subscription: @subscription, quantity: 2, status: 'cancelled')
      @tea_subscription_7 = create(:tea_subscription, tea: @tea_1, subscription: @subscription_2, quantity: 2, status: 'active')
    end

    it "returns user's active unique teas when given valid data" do
      get "/api/v1/users/#{@user.id}/tea_subscriptions"

      json = JSON.parse(response.body, symbolize_names:true)

      expect(response).to be_successful
      expect(json).to be_a(Hash)
      expect(json[:data]).to be_a(Hash)
      check_hash_structure(json[:data], :id, String)
      check_hash_structure(json[:data], :type, String)
      expect(json[:data][:type]).to eq("user_tea_subscriptions")
      check_hash_structure(json[:data], :attributes, Hash)
      check_hash_structure(json[:data][:attributes], :tea_subscriptions, Array)
      expect(json[:data][:attributes][:tea_subscriptions].count).to eq(5)

      tea_subscription = json[:data][:attributes][:tea_subscriptions].first
      check_hash_structure(tea_subscription, :id, Integer)
      check_hash_structure(tea_subscription, :title, String)
      expect(tea_subscription[:title]).to eq(@tea_5.title)
      check_hash_structure(tea_subscription, :description, String)
      check_hash_structure(tea_subscription, :brew_temp, Float)
      check_hash_structure(tea_subscription, :brew_time, Integer)
      check_hash_structure(tea_subscription, :box_count, Integer)
      check_hash_structure(tea_subscription, :status, String)
    end

    it "returns user's active unique teas by min brew temp when given valid data" do
      brew_temp = 190
      get "/api/v1/users/#{@user.id}/tea_subscriptions?min_brew_temp=#{brew_temp}"

      json = JSON.parse(response.body, symbolize_names:true)

      expect(response).to be_successful
      expect(json).to be_a(Hash)
      expect(json[:data][:attributes][:tea_subscriptions].count).to eq(4)
      tea_subscriptions = json[:data][:attributes][:tea_subscriptions]

      expect(tea_subscriptions.first[:id]).to eq(@tea_5.id)
      expect(tea_subscriptions.last[:id]).to eq(@tea_3.id)
    end

    it "returns user's active unique teas by max brew temp when given valid data" do
      brew_temp = 190
      get "/api/v1/users/#{@user.id}/tea_subscriptions?max_brew_temp=#{brew_temp}"

      json = JSON.parse(response.body, symbolize_names:true)

      expect(response).to be_successful
      expect(json).to be_a(Hash)
      expect(json[:data][:attributes][:tea_subscriptions].count).to eq(2)
      tea_subscriptions = json[:data][:attributes][:tea_subscriptions]

      expect(tea_subscriptions.first[:id]).to eq(@tea_4.id)
      expect(tea_subscriptions.last[:id]).to eq(@tea_3.id)
    end

    it "returns user's active unique teas by min brew time when given valid data" do
      brew_time = 6
      get "/api/v1/users/#{@user.id}/tea_subscriptions?min_brew_time=#{brew_time}"

      json = JSON.parse(response.body, symbolize_names:true)

      expect(response).to be_successful
      expect(json).to be_a(Hash)
      expect(json[:data][:attributes][:tea_subscriptions].count).to eq(3)
      tea_subscriptions = json[:data][:attributes][:tea_subscriptions]

      expect(tea_subscriptions.first[:id]).to eq(@tea_5.id)
      expect(tea_subscriptions.last[:id]).to eq(@tea_4.id)
    end

    it "returns user's active unique teas by max brew time when given valid data" do
      brew_time = 6
      get "/api/v1/users/#{@user.id}/tea_subscriptions?max_brew_time=#{brew_time}"

      json = JSON.parse(response.body, symbolize_names:true)

      expect(response).to be_successful
      expect(json).to be_a(Hash)
      expect(json[:data][:attributes][:tea_subscriptions].count).to eq(3)
      tea_subscriptions = json[:data][:attributes][:tea_subscriptions]

      expect(tea_subscriptions.first[:id]).to eq(@tea_5.id)
      expect(tea_subscriptions.last[:id]).to eq(@tea_3.id)
    end

    it "returns user's active unique teas by brew temp and brew time when given valid data" do
      brew_temp = 190
      brew_time = 6
      get "/api/v1/users/#{@user.id}/tea_subscriptions?min_brew_temp=#{brew_temp}&max_brew_time=#{brew_time}"

      json = JSON.parse(response.body, symbolize_names:true)

      expect(response).to be_successful
      expect(json).to be_a(Hash)
      expect(json[:data][:attributes][:tea_subscriptions].count).to eq(3)
      tea_subscriptions = json[:data][:attributes][:tea_subscriptions]

      expect(tea_subscriptions.first[:id]).to eq(@tea_5.id)
      expect(tea_subscriptions.last[:id]).to eq(@tea_3.id)
    end
  end
end
