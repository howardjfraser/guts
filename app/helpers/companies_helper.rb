module CompaniesHelper

  def user_count(company)
    User.by_company(company).excluding_root.count
  end

end
