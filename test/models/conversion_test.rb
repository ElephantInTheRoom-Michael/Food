require "test_helper"

class ConversionTest < ActiveSupport::TestCase
  test "should save a conversion with serving, volume, and weight" do
    assert Conversion.new(
      ingredient: ingredients(:onion),
      serving: 1,
      volume: 2,
      volume_unit: volume_units(:liter),
      weight: 100,
      weight_unit: weight_units(:gram),
    ).save
  end

  test "should require an ingredient" do
    conversion = Conversion.new
    assert conversion.invalid?
    check_model_has_error(conversion, :ingredient, :blank)
  end

  test "should require a unit for volume" do
    conversion = Conversion.new(
      ingredient: ingredients(:onion),
      serving: 1,
      volume: 2,
    )
    assert conversion.invalid?
    check_model_has_error(conversion, :volume_unit, :blank)
    assert_empty conversion.errors.where(:weight_unit)
  end

  test "should require a unit for weight" do
    conversion = Conversion.new(
      ingredient: ingredients(:onion),
      serving: 1,
      weight: 100,
    )
    assert conversion.invalid?
    check_model_has_error(conversion, :weight_unit, :blank)
    assert_empty conversion.errors.where(:volume_unit)
  end

  test "should not allow units for volume without a corresponding value" do
    conversion = Conversion.new(
      ingredient: ingredients(:onion),
      serving: 1,
      volume_unit: volume_units(:liter),
    )
    assert conversion.invalid?
    check_model_has_error(conversion, :volume, :blank)
    assert_empty conversion.errors.where(:weight)
  end

  test "should not allow units for weight without a corresponding value" do
    conversion = Conversion.new(
      ingredient: ingredients(:onion),
      serving: 1,
      weight_unit: weight_units(:gram),
    )
    assert conversion.invalid?
    check_model_has_error(conversion, :weight, :blank)
    assert_empty conversion.errors.where(:volume)
  end

  test "should require at least two values set out of volume, weight, or serving" do
    conversion = Conversion.new(
      ingredient: ingredients(:onion),
      serving: 1,
    )
    assert conversion.invalid?
    check_model_has_error(conversion, :base, :missing_conversion)
  end

  test "should not allow duplicate serving values" do
    conversion = Conversion.new(ingredient: ingredients(:onion), serving: 1, volume: 2, volume_unit: volume_units(:liter))
    assert conversion.save
    conversion2 = conversion.dup
    conversion2.volume = 3
    assert_not conversion2.save
    check_model_has_error(conversion2, :serving, :taken)
  end

  test "should not allow duplicate volume values" do
    conversion = Conversion.new(ingredient: ingredients(:onion), serving: 1, volume: 2, volume_unit: volume_units(:liter))
    assert conversion.save
    conversion2 = conversion.dup
    conversion2.serving = 2
    assert_not conversion2.save
    check_model_has_error(conversion2, :volume, :taken)
  end

  test "should not allow duplicate weight values" do
    conversion = Conversion.new(ingredient: ingredients(:onion), serving: 1, weight: 100, weight_unit: weight_units(:gram))
    assert conversion.save
    conversion2 = conversion.dup
    conversion2.serving = 2
    assert_not conversion2.save
    check_model_has_error(conversion2, :weight, :taken)
  end
end
