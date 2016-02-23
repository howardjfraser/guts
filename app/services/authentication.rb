class Authentication
  def initialize(session, cookies = nil)
    @session = session
    @cookies = cookies
  end

  def log_in(user)
    @session[:user_id] = user.id
  end

  def log_out
    forget current_user
    @session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    if (user_id = @session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = @cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && Authentication.authenticated?(user, :remember, @cookies[:remember_token])
        Authentication.new(@session).log_in user
        @current_user = user
      end
    end
  end

  def remember(user)
    user.remember
    @cookies.permanent.signed[:user_id] = user.id
    @cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    @cookies.delete(:user_id)
    @cookies.delete(:remember_token)
  end

  def self.authenticated?(user, attribute, token)
    digest = user.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(string)
    BCrypt::Password.create(string, cost: Authentication.cost)
  end

  def self.cost
    ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
  end
end
