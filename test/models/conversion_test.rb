require "test_helper"

class ConversionTest < ActiveSupport::TestCase
  test "should allow a conversion with serving, volume, and weight" do
    conversion = Conversion.new(ingredient: ingredients(:onion), serving: 1, volume: 2, volume_unit: volume_units(:liter), weight: 100, weight_unit: weight_units(:gram))
    assert conversion.save
  end

  test "should require an ingredient" do
    conversion = Conversion.new
    assert_not conversion.save
    assert_equal :blank, conversion.errors.where(:ingredient).first.type
  end
end
