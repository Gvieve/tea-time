require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'relationships' do
    it {should belong_to :user}
    it {should belong_to :plan}
    it {should have_many :tea_subscriptions}
    it {should have_many(:teas).through(:tea_subscriptions)}
  end

  describe 'validations' do
    it {should validate_presence_of :user_id }
    it {should validate_presence_of :status }
    it {should validate_presence_of :process_on_date }
    it {should validate_presence_of :plan_id }
    it { should define_enum_for :status }
  end

  describe 'subscription status' do
    before :each do
      user = create(:user)
      plan = create(:plan)
      @subscription = create(:subscription, status: 0, user_id: user.id, plan_id: plan.id)
    end

    it "subscription status is active when created" do
      expect(@subscription.status).to eq('active')
      expect(@subscription.active?).to eq(true)
      expect(@subscription.cancelled?).to eq(false)
      expect(@subscription.paused?).to eq(false)
    end

    it "subscription status can be updated to cancelled" do
      @subscription.update(status: 'cancelled')

      expect(@subscription.status).to eq('cancelled')
      expect(@subscription.active?).to eq(false)
      expect(@subscription.cancelled?).to eq(true)
      expect(@subscription.paused?).to eq(false)
    end

    it "subscription status can be updated to paused" do
      @subscription.update(status: 'paused')

      expect(@subscription.status).to eq('paused')
      expect(@subscription.active?).to eq(false)
      expect(@subscription.cancelled?).to eq(false)
      expect(@subscription.paused?).to eq(true)
    end
  end
end
