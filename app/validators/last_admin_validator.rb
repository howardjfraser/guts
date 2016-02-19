class LastAdminValidator  < ActiveModel::Validator

  def validate user
    user.errors.add(:role, 'You can’t remove the last administrator') if possible_admin_role_removal?(user) && !user.has_admin_colleague?
  end

  def possible_admin_role_removal? user
    user.role_changed? && user.role != 'admin'
  end

end
