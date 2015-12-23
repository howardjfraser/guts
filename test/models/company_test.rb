require 'test_helper'

class CompanyTest < ActiveSupport::TestCase

  def setup
    @company = Company.new(name: "Example Company")
  end

  test "valid company" do
    assert @company.valid?
  end

  test "name is requred" do
    @company.name = nil
    refute @company.valid?
  end

  test "max name length" do
    too_long = "a" * 51
    @company.name = too_long
    refute @company.valid?
  end

end
