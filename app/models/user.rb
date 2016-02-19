class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

  has_secure_password validations: false
  belongs_to :company, inverse_of: :users

  # validation

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  # TODO: remove allow nil by creating separate credentials model?
  validates :password, presence: true, length: {  minimum: 6 }, allow_nil: true

  validates :company, presence: true

  ROLES = %w(user admin root)
  validates :role, inclusion: ROLES[0...-1]

  validates_with LastAdminValidator

  # queries

  scope :sorted, -> { order('lower(name)') }
  scope :exclude_root, -> { sorted.where.not(role: 'root') }
  scope :company, ->(company) { exclude_root.where('company_id = ?', company) }
  scope :activated, -> (company) { company(company).where(activated: true) }
  scope :invited, -> (company) { company(company).where(activated: false) }

  # helpers

  def admin?
    role == 'admin' || role == 'root'
  end

  def root?
    role == 'root'
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

  def self.digest(string)
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
    update_attribute(:activation_digest, activation_digest)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def has_admin_colleague?
    colleagues = company.users.select { |u| u != self }
    colleagues.count { |u| u.role == 'admin' } > 0
  end

  private

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def downcase_email
    email.downcase!
  end

end
