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

  test "should limit numbers to DB precision" do
    amount = Amount.new(serving: 10_000)
    assert_not amount.valid?
    check_model_has_error(amount, :serving, :less_than)
    amount.serving = nil
    amount.weight = 10_000
    assert_not amount.valid?
    check_model_has_error(amount, :weight, :less_than)
    amount.weight = nil
    amount.volume = 10_000
    assert_not amount.valid?
    check_model_has_error(amount, :volume, :less_than)
  end

  test "have nice labels" do
    assert_equal "1 onion", Amount.new(
      serving: 1,
      ingredient: Ingredient.new(name: "onion")
    ).label

    assert_equal "1 large onion", Amount.new(
      serving: 1,
      serving_variant: "large",
      ingredient: Ingredient.new(name: "onion")
    ).label

    assert_equal "2 onions", Amount.new(
      serving: 2,
      ingredient: Ingredient.new(name: "onion")
    ).label

    assert_equal "1 & 1/2 onions", Amount.new(
      serving: 1.5,
      ingredient: Ingredient.new(name: "onion")
    ).label
  end

  test "have nice labels for fractions" do
    [
      [ "1/2", 1.0 / 2.0 ],
      [ "1/3", 1.0 / 3.0 ], [ "2/3", 2.0 / 3.0 ],
      [ "1/4", 1.0 / 4.0 ], [ "3/4", 3.0 / 4.0 ],
      [ "1/5", 1.0 / 5.0 ], [ "2/5", 2.0 / 5.0 ], [ "3/5", 3.0 / 5.0 ], [ "4/5", 4.0 / 5.0 ],
      [ "1/6", 1.0 / 6.0 ], [ "5/6", 5.0 / 6.0 ],
      [ "1/8", 1.0 / 8.0 ], [ "3/8", 3.0 / 8.0 ], [ "5/8", 5.0 / 8.0 ], [ "7/8", 7.0 / 8.0 ],
      [ "1/10", 1.0 / 10.0 ], [ "3/10", 3.0 / 10.0 ], [ "7/10", 7.0 / 10.0 ], [ "9/10", 9.0 / 10.0 ],
      [ "1/12", 1.0 / 12.0 ], [ "5/12", 5.0 / 12.0 ], [ "7/12", 7.0 / 12.0 ], [ "11/12", 11.0 / 12.0 ],
      [ "1/16", 1.0 / 16.0 ], [ "3/16", 3.0 / 16.0 ], [ "5/16", 5.0 / 16.0 ], [ "7/16", 7.0 / 16.0 ],
      [ "9/16", 9.0 / 16.0 ], [ "11/16", 11.0 / 16.0 ], [ "13/16", 13.0 / 16.0 ], [ "15/16", 15.0 / 16.0 ],
    ].each do |test_pair|
      assert_equal "#{test_pair.first} onion", Amount.new(
        serving: test_pair.last,
        ingredient: Ingredient.new(name: "onion")
      ).label
    end

    (1...10).each do |test_value|
      bd = BigDecimal(test_value / 10.0)
      expected = {
        1 => "1/10", 2 => "1/5", 3 => "3/10", 4 => "2/5", 5 => "1/2", 6 => "3/5", 7 => "7/10",
        8 => "4/5",  9 => "9/10",
      }
      assert_equal "#{expected.fetch(test_value, bd)} onion", Amount.new(
        serving: bd,
        ingredient: Ingredient.new(name: "onion")
      ).label
    end

    (1...100).each do |test_value|
      bd = BigDecimal(test_value / 100.0)
      expected = {
        10 => "1/10", 20 => "1/5", 25 => "1/4", 30 => "3/10", 40 => "2/5", 50 => "1/2", 60 => "3/5",
        70 => "7/10", 75 => "3/4", 80 => "4/5", 90 => "9/10",
      }
      assert_equal "#{expected.fetch(test_value, bd)} onion", Amount.new(
        serving: bd,
        ingredient: Ingredient.new(name: "onion")
      ).label
    end

    (1...1000).each do |test_value|
      bd = BigDecimal(test_value / 1000.0)
      expected = {
        62 => "1/16", 63 => "1/16", 83 => "1/12", 84 => "1/12", 100 => "1/10", 125 => "1/8", 166 => "1/6",
        167 => "1/6", 187 => "3/16", 188 => "3/16", 200 => "1/5", 250 => "1/4", 300 => "3/10", 312 => "5/16",
        313 => "5/16", 333 => "1/3", 334 => "1/3", 375 => "3/8", 400 => "2/5", 416 => "5/12", 417 => "5/12",
        437 => "7/16", 438 => "7/16", 500 => "1/2", 562 => "9/16", 563 => "9/16", 583 => "7/12", 584 => "7/12",
        600 => "3/5", 625 => "5/8", 666 => "2/3", 667 => "2/3", 687 => "11/16", 688 => "11/16", 700 => "7/10",
        750 => "3/4", 800 => "4/5", 812 => "13/16", 813 => "13/16", 833 => "5/6", 834 => "5/6", 875 => "7/8",
        900 => "9/10", 916 => "11/12", 917 => "11/12", 937 => "15/16", 938 => "15/16",
      }
      assert_equal "#{expected.fetch(test_value, bd)} onion", Amount.new(
        serving: bd,
        ingredient: Ingredient.new(name: "onion")
      ).label
    end
  end
end
