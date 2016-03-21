class LastAdminValidator < ActiveModel::Validator
  def validate(user)
    return unless admin_role_removed?(user) && user.last_admin?
    user.errors.add(:role, 'You can’t remove the last administrator')
  end

  private

  def admin_role_removed?(user)
    user.role_changed? && user.role != 'admin'
  end
end
