class Company < ActiveRecord::Base
  has_many :users, inverse_of: :company, dependent: :destroy
  accepts_nested_attributes_for :users

  validates :name, presence: true, length: { maximum: 50 }
  validates :users, presence: true

  def to_s
    "Company: #{name}"
  end
end
