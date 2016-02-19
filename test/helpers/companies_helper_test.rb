require 'test_helper'

class CompaniesHelperTest < ActionView::TestCase
  test 'user count excludes root' do
    assert @howard.company == @hogg
    assert user_count(@hogg) == (@hogg.users.count - 1)
  end
end
