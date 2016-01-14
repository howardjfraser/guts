class Company < ActiveRecord::Base
  has_many :users

  validates :name, presence: true, length: {maximum: 50}
  validates :users, presence: true

end
