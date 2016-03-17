class Update < ActiveRecord::Base
  belongs_to :user

  validates :message, presence: true, length: { maximum: 256 }
  validates :user, presence: true

  def to_s
    "Update: #{message.truncate(24)}"
  end
end
