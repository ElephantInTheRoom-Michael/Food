require "test_helper"

class WeightUnitTest < ActiveSupport::TestCase
  test "should save a unit with an abbreviation" do
    unit = WeightUnit.new(name: "gram", abbreviation: "g")
    assert unit.save
    assert_equal WeightUnit.find(unit.id), unit
  end

  test "should save a unit without an abbreviation" do
    unit = WeightUnit.new(name: "gram")
    assert unit.save
    assert_equal WeightUnit.find(unit.id), unit
  end

  test "should not save a unit without a name" do
    unit = WeightUnit.new
    assert_not unit.save
    assert_equal :name, unit.errors.first.attribute
    assert_equal :blank, unit.errors.first.type
  end
end
