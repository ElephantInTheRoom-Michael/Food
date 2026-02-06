require "test_helper"

class AmountTest < ActiveSupport::TestCase
  test "should save an amount with a serving" do
    assert Amount.new(ingredient: ingredients(:onion), serving: 2).save
  end

  test "should save an amount with a volume" do
    assert Amount.new(ingredient: ingredients(:onion), volume: 1, volume_unit: volume_units(:liter)).save
  end

  test "should save an amount with a weight" do
    assert Amount.new(ingredient: ingredients(:onion), weight: 1, weight_unit: weight_units(:gram)).save
  end

  test "require an ingredient" do
    amount = Amount.new(serving: 1)
    assert_not amount.valid?
    check_model_has_error(amount, :ingredient, :blank)
  end

  test "require a unit for volume" do
    amount = Amount.new(
      ingredient: ingredients(:onion),
      volume: 2,
    )
    assert amount.invalid?
    check_model_has_error(amount, :volume_unit, :blank)
    assert_empty amount.errors.where(:weight_unit)
  end

  test "require a unit for weight" do
    amount = Amount.new(
      ingredient: ingredients(:onion),
      weight: 100,
    )
    assert amount.invalid?
    check_model_has_error(amount, :weight_unit, :blank)
    assert_empty amount.errors.where(:volume_unit)
  end

  test "should not allow units for volume without a corresponding value" do
    amount = Amount.new(
      ingredient: ingredients(:onion),
      volume_unit: volume_units(:liter),
    )
    assert amount.invalid?
    check_model_has_error(amount, :volume, :blank)
    assert_empty amount.errors.where(:weight)
  end

  test "should not allow units for weight without a corresponding value" do
    amount = Amount.new(
      ingredient: ingredients(:onion),
      weight_unit: weight_units(:gram),
    )
    assert amount.invalid?
    check_model_has_error(amount, :weight, :blank)
    assert_empty amount.errors.where(:volume)
  end

  test "require exactly one value set" do
    amount = Amount.new(ingredient: ingredients(:onion))
    assert amount.invalid?
    check_model_has_error(amount, :base, :blank)
    amount.serving = 2
    amount.volume = 2
    amount.volume_unit = volume_units(:liter)
    assert amount.invalid?
    check_model_has_error(amount, :serving, :present)
    check_model_has_error(amount, :volume, :present)
    amount.weight = 100
    amount.weight_unit = weight_units(:gram)
    assert amount.invalid?
    check_model_has_error(amount, :serving, :present)
    check_model_has_error(amount, :volume, :present)
    check_model_has_error(amount, :weight, :present)
    amount.serving = nil
    assert amount.invalid?
    check_model_has_error(amount, :volume, :present)
    check_model_has_error(amount, :weight, :present)
  end
end
