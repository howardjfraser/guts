class LastAdminValidator < ActiveModel::Validator
  def validate(user)
    if admin_role_removal?(user) && user.last_admin?
      user.errors.add(:role, 'You can’t remove the last administrator')
    end
  end

  private

  def admin_role_removal?(user)
    user.role_changed? && user.role != 'admin'
  end
end
