class Company < ActiveRecord::Base
  has_many :users

  # has owner? (or is_owner on user?)

  # trial expiry date

  # state [trial, subscribed, expired] (or derive?)

  validates :name, presence: true, length: {maximum: 50}
  validates :users, presence: true

end
