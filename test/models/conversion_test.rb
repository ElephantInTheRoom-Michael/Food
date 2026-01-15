require "test_helper"

class ConversionTest < ActiveSupport::TestCase
  test "should allow a conversion with serving, volume, and weight" do
    assert Conversion.new(
      ingredient: ingredients(:onion),
      serving: 1,
      volume: 2,
      volume_unit: volume_units(:liter),
      weight: 100,
      weight_unit: weight_units(:gram),
    ).valid?
  end

  test "should require an ingredient" do
    conversion = Conversion.new
    assert conversion.invalid?
    assert_equal :blank, conversion.errors.where(:ingredient).first.type
  end

  test "should require a unit for volume" do
    conversion = Conversion.new(
      ingredient: ingredients(:onion),
      serving: 1,
      volume: 2,
    )
    assert conversion.invalid?
    assert_equal :blank, conversion.errors.where(:volume_unit).first.type
    assert_empty conversion.errors.where(:weight_unit)
  end

  test "should require a unit for weight" do
    conversion = Conversion.new(
      ingredient: ingredients(:onion),
      serving: 1,
      weight: 100,
    )
    assert conversion.invalid?
    assert_equal :blank, conversion.errors.where(:weight_unit).first.type
    assert_empty conversion.errors.where(:volume_unit)
  end

  test "should not allow units for volume without a corresponding value" do
    conversion = Conversion.new(
      ingredient: ingredients(:onion),
      serving: 1,
      volume_unit: volume_units(:liter),
    )
    assert conversion.invalid?
    assert_equal :blank, conversion.errors.where(:volume).first.type
    assert_empty conversion.errors.where(:weight)
  end

  test "should not allow units for weight without a corresponding value" do
    conversion = Conversion.new(
      ingredient: ingredients(:onion),
      serving: 1,
      weight_unit: weight_units(:gram),
    )
    assert conversion.invalid?
    assert_equal :blank, conversion.errors.where(:weight).first.type
    assert_empty conversion.errors.where(:volume)
  end

  test "should require at least two values set out of volume, weight, or serving" do
    conversion = Conversion.new(
      ingredient: ingredients(:onion),
      serving: 1,
    )
    assert conversion.invalid?
    assert_equal :missing_conversion, conversion.errors.where(:base).first.type
  end

  test "should not allow duplicate serving values" do
    conversion = Conversion.new(ingredient: ingredients(:onion), serving: 1, volume: 2, volume_unit: volume_units(:liter))
    assert conversion.save
    conversion2 = conversion.dup
    conversion2.volume = 3
    assert_not conversion2.save
    assert_equal :taken, conversion2.errors.where(:serving).first.type
  end

  test "should not allow duplicate volume values" do
    conversion = Conversion.new(ingredient: ingredients(:onion), serving: 1, volume: 2, volume_unit: volume_units(:liter))
    assert conversion.save
    conversion2 = conversion.dup
    conversion2.serving = 2
    assert_not conversion2.save
    assert_equal :taken, conversion2.errors.where(:volume).first.type
  end

  test "should not allow duplicate weight values" do
    conversion = Conversion.new(ingredient: ingredients(:onion), serving: 1, weight: 100, weight_unit: weight_units(:gram))
    assert conversion.save
    conversion2 = conversion.dup
    conversion2.serving = 2
    assert_not conversion2.save
    assert_equal :taken, conversion2.errors.where(:weight).first.type
  end
end
