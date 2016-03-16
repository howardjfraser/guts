class Update < ActiveRecord::Base
  belongs_to :user

  validates :message, presence: true, length: { maximum: 256 }
  validates :user, presence: true

  default_scope -> { order(created_at: :desc) }
end
