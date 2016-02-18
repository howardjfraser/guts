class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

  ROLES = %w[user admin root]
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_secure_password validations: false
  belongs_to :company, inverse_of: :users


  # validation

  validates :name, presence: true, length: {maximum: 50}

  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
    uniqueness: {case_sensitive: false}

  # TODO remove allow nil by creating separate credentials model?
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  validates :company, presence: true

  validate :at_least_one_admin, on: :update

  validates_inclusion_of :role, in: ROLES[0...-1]


  # queries

  default_scope { order('lower(name)') }
  scope :exclude_root, -> { where.not(role: "root") }
  scope :company, ->(company) { exclude_root.where("company_id = ?", company)}
  scope :activated, -> (company) { company(company).where(activated: true)}
  scope :invited, -> (company) { company(company).where(activated: false)}


  #helpers

  def admin?
    self.role == "admin" || self.role == "root"
  end

  def root?
    self.role == "root"
  end


  # auth

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
    # TODO - hmmm...
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def renew_activation_digest
    create_activation_digest
  end

  private

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def downcase_email
    self.email.downcase!
  end

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

  def User.new_token
    SecureRandom.urlsafe_base64
  end

end
