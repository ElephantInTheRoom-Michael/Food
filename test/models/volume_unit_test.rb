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

  test "require a name" do
    unit = VolumeUnit.new
    assert_not unit.valid?
    check_model_has_error(unit, :name, :blank)
  end
end
