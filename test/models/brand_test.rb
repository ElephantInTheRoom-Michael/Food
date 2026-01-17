require "test_helper"

class BrandTest < ActiveSupport::TestCase
  test "should save a brand with a name" do
    brand = Brand.new(name: "test")
    assert brand.save
  end

  test "requires a name" do
    brand = Brand.new
    assert_not brand.valid?
    check_model_has_error(brand, :name, :blank)
  end
end
