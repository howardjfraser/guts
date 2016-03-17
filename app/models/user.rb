class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

  has_secure_password validations: false
  belongs_to :company, inverse_of: :users

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: {  minimum: 6 }, allow_nil: true

  validates :company, presence: true

  ROLES = %w(user admin root).freeze
  validates :role, inclusion: ROLES[0...-1]

  validates_with LastAdminValidator

  def last_admin?
    colleagues = company.users.select { |u| u != self }
    colleagues.count { |u| u.role == 'admin' } == 0
  end

  scope :sorted, -> { order('lower(name)') }
  scope :exclude_root, -> { sorted.where.not(role: 'root') }
  scope :company, ->(company) { exclude_root.where('company_id = ?', company) }
  scope :activated, -> (company) { company(company).where(activated: true) }
  scope :invited, -> (company) { company(company).where(activated: false) }

  def admin?
    role == 'admin' || role == 'root'
  end

  def root?
    role == 'root'
  end

  def remember
    self.remember_token = Authentication.new_token
    update_attribute(:remember_digest, Authentication.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def create_reset_digest
    self.reset_token = Authentication.new_token
    update_columns(reset_digest: Authentication.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def renew_activation_digest
    create_activation_digest
    update_attribute(:activation_digest, activation_digest)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def create_activation_digest
    self.activation_token  = Authentication.new_token
    self.activation_digest = Authentication.digest(activation_token)
  end

  def downcase_email
    email.downcase!
  end

  def to_s
    "User: #{name} / #{email}"
  end
end
