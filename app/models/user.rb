class User < ApplicationRecord
  has_one :user_profile

  validates :email, presence: true
  validates_uniqueness_of :email
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_save {self.email = email.try(:downcase)}
end
