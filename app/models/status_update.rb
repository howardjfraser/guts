class StatusUpdate < ActiveRecord::Base
  belongs_to :user
  validates :message, presence: true, length: { maximum: 256 }
  validates :user, presence: true
end
