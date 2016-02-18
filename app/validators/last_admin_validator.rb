class LastAdminValidator  < ActiveModel::Validator

  def validate user
    if possible_admin_role_removal?(user) && no_other_admins?(user)
      user.errors.add(:role, 'You can’t remove the last administrator')
    end
  end

  def possible_admin_role_removal? user
    user.role_changed? && user.role != 'admin'
  end

  def no_other_admins? user
    colleagues = user.company.users.select { |u| u != user }
    colleagues.count { |u| u.role == 'admin' } == 0
  end

end
