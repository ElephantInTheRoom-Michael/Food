require "test_helper"

class VolumeUnitTest < ActiveSupport::TestCase
  test "should save a unit with an abbreviation" do
    unit = VolumeUnit.new(name: "liter", abbreviation: "l")
    assert unit.save
    assert_equal VolumeUnit.find(unit.id), unit
  end

  test "should save a unit without an abbreviation" do
    unit = VolumeUnit.new(name: "pinch")
    assert unit.save
    assert_equal VolumeUnit.find(unit.id), unit
  end

  test "should not save a unit without a name" do
    unit = VolumeUnit.new
    assert_not unit.save
    assert_equal :name, unit.errors.first.attribute
    assert_equal :blank, unit.errors.first.type
  end
end
