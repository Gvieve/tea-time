require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe "validations" do
    it { should validate_presence_of :description }
    it { should validate_presence_of :weekly_frequency }
    it { should validate_numericality_of(:weekly_frequency).only_integer }
    it {should validate_numericality_of(:weekly_frequency).is_greater_than_or_equal_to(1)}
    it {should validate_numericality_of(:weekly_frequency).is_less_than_or_equal_to(12)}
  end

  describe 'relationships' do
    it {should have_many :subscriptions}
  end
end
