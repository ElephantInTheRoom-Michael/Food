require "test_helper"

class BrandTest < ActiveSupport::TestCase
  test "requires a name" do
    brand = Brand.new
    assert_not brand.valid?
    assert_equal :blank, brand.errors.where(:name).first.type
  end
end
