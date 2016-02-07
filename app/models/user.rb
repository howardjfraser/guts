class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token

  ROLES = %w[user admin root]

  before_save :downcase_email
  before_create :create_activation_digest

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: 50}

  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
    uniqueness: {case_sensitive: false}

  # TODO remove nil pw allowed once pw is removed from user form
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  validates :company, presence: true

  validate :at_least_one_admin, on: :update

  validates_inclusion_of :role, in: ROLES[0...-1]

  has_secure_password

  belongs_to :company, inverse_of: :users

  def admin?
    self.role == "admin" || self.role == "root"
  end

  def root?
    self.role == "root"
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def User.digest(string)
    # TODO - cost stuff???
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def send_activation_email
    UserMailer.activation(self).deliver_now
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def downcase_email
    self.email.downcase!
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  # if admin role has been removed, check there is another admin
  def at_least_one_admin
    if (self.role_changed? && self.role != "admin")
      if (colleagues.select { |u| u.role == "admin" }.count == 0)
        errors.add(:role, "You can’t remove the last administrator")
      end
    end
  end

  def colleagues
    self.company.users.select { |u| u != self }
  end

end
