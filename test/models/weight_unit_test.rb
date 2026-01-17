require "test_helper"

class WeightUnitTest < ActiveSupport::TestCase
  test "should save a unit with an abbreviation" do
    unit = WeightUnit.new(name: "gram", abbreviation: "g")
    assert unit.save
    assert_equal WeightUnit.find(unit.id), unit
  end

  test "should save a unit without an abbreviation" do
    unit = WeightUnit.new(name: "test")
    assert unit.save
    assert_equal WeightUnit.find(unit.id), unit
  end

  test "require a name" do
    unit = WeightUnit.new
    assert_not unit.save
    check_model_has_error(unit, :name, :blank)
  end
end
