module SessionsHelper
  def log_in(user)
    Authentication.new(session).log_in user
  end

  def log_out
    Authentication.new(session, cookies).log_out
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user
    Authentication.new(session, cookies).current_user
  end

  def current_company
    current_user.company
  end

  def current_user?(user)
    user == current_user
  end

  def remember(user)
    Authentication.new(session, cookies).remember user
  end

  def forget(user)
    Authentication.new(session, cookies).forget user
  end
end
