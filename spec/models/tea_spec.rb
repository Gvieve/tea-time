require 'rails_helper'

RSpec.describe Tea, type: :model do
  describe 'relationships' do
    it {should have_many :tea_subscriptions}
    it {should have_many(:subscriptions).through(:tea_subscriptions)}
  end

  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :temperature }
    it { should validate_presence_of :brew_time }
    it { should validate_presence_of :box_count }
    it { should validate_presence_of :price }
    it { should validate_uniqueness_of(:title).scoped_to(:box_count) }
  end

  describe 'validate uniqueness scoped to box_count' do
    it "cannot create tea with the same title and box_count" do
      tea = create(:tea)

      new_tea = Tea.new(title: tea.title, box_count: tea.box_count, temperature: 105, brew_time: 6, price: 10.89)

      expect(new_tea.save).to eq(false)
    end
  end
end
