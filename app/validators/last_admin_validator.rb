class LastAdminValidator < ActiveModel::Validator
  def validate(user)
    if possible_admin_role_removal?(user) && user.last_admin?
      user.errors.add(:role, 'You can’t remove the last administrator')
    end
  end

  # lose the possible...
  def possible_admin_role_removal?(user)
    user.role_changed? && user.role != 'admin'
  end
end
