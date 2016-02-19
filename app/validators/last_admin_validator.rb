class LastAdminValidator  < ActiveModel::Validator

  def validate user
    if possible_admin_role_removal?(user) && !user.has_admin_colleague?
      user.errors.add(:role, 'You can’t remove the last administrator')
    end
  end

  def possible_admin_role_removal? user
    user.role_changed? && user.role != 'admin'
  end

end
