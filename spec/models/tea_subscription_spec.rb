require 'rails_helper'

RSpec.describe TeaSubscription, type: :model do
  describe 'relationships' do
    it {should belong_to :subscription}
    it {should belong_to :tea}
  end

  describe 'validations' do
    it {should validate_presence_of :tea_id }
    it {should validate_presence_of :subscription_id }
    it {should validate_presence_of :current_price }
    it {should validate_presence_of :quantity }
    it {should validate_presence_of :status }
    it { should define_enum_for :status }
  end

  describe 'tea subscription status' do
    before :each do
      @tea_subscription = create(:subscription)
    end

    it "tea_subscription status is active when created" do
      expect(@tea_subscription.status).to eq('active')
      expect(@tea_subscription.active?).to eq(true)
      expect(@tea_subscription.cancelled?).to eq(false)
      expect(@tea_subscription.paused?).to eq(false)
    end

    it "tea_subscription status can be updated to cancelled" do
      @tea_subscription.update(status: 'cancelled')

      expect(@tea_subscription.status).to eq('cancelled')
      expect(@tea_subscription.active?).to eq(false)
      expect(@tea_subscription.cancelled?).to eq(true)
      expect(@tea_subscription.paused?).to eq(false)
    end

    it "tea_subscription status can be updated to paused" do
      @tea_subscription.update(status: 'paused')

      expect(@tea_subscription.status).to eq('paused')
      expect(@tea_subscription.active?).to eq(false)
      expect(@tea_subscription.cancelled?).to eq(false)
      expect(@tea_subscription.paused?).to eq(true)
    end
  end
end
