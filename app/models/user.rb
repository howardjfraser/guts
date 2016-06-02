class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token, :send_invitation

  before_save :downcase_email

  has_secure_password validations: false
  belongs_to :company, inverse_of: :users
  has_many :updates, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: {  minimum: 6 }, allow_nil: true

  validates :company, presence: true

  ROLES = %w(user admin root).freeze
  validates :role, inclusion: ROLES[0...-1]

  STATUSES = %w(new invited active).freeze
  validates :status, inclusion: STATUSES

  validates_with LastAdminValidator

  def last_admin?
    colleagues = company.users.select { |u| u != self }
    colleagues.count { |u| u.role == 'admin' } == 0
  end

  scope :sorted, -> { order('lower(name)') }
  scope :exclude_root, -> { sorted.where.not(role: 'root') }
  scope :company, ->(company) { exclude_root.where('company_id = ?', company) }
  scope :new_users, -> (company) { company(company).where(status: 'new') }
  scope :invited, -> (company) { company(company).where(status: 'invited') }
  scope :active, -> (company) { company(company).where(status: 'active') }

  def admin?
    role == 'admin' || role == 'root'
  end

  def root?
    role == 'root'
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_attribute(:status, 'active')
  end

  def new?
    status == 'new'
  end

  def invited?
    status == 'invited'
  end

  def active?
    status == 'active'
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def to_s
    "User: #{name} / #{email}"
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(string)
    BCrypt::Password.create(string, cost: User.cost)
  end

  def self.cost
    ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
  end

  def invite
    return if send_invitation == '0'
    update_attributes(activation_digest: create_activation_digest, status: 'invited')
    UserMailer.invite(self).deliver_now
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
