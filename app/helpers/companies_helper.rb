module CompaniesHelper

  def user_count(company)
    company.users.exclude_root.count
  end

end
