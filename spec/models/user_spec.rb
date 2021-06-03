require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
  end

  describe 'relationships' do
    it {should have_one :user_profile}
  end

  describe 'email format validation' do
    it "creates a user with a valid email format" do
      user = User.create!(email: 'teaRobber@email.com')

      expect(user.email).to eq('tearobber@email.com')
    end

    it "should not create a user with a invalid email format" do
      user = User.new(email: 'meangirl.email.com')

      expect(user.save).to eq(false)
    end
  end

  describe 'call backs' do
    it "downcases an email when creating a new record" do
      user = User.create!(email: 'teaRobber@email.com')

      expect(user.email).to eq('tearobber@email.com')
    end

    it "downcases an email when updating a new record" do
      user = User.create!(email: 'teaRobber@email.com')
      expect(user.email).to eq('tearobber@email.com')

      user.update(email: "MYNEWemail@yes.com")
      expect(user.email).to eq('mynewemail@yes.com')
    end
  end
end
