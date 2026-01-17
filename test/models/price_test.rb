require "test_helper"

class PriceTest < ActiveSupport::TestCase
  test "should save a price with all valid columns" do
    price = Price.new(
      description: "one onion",
      amount: amounts(:one_onion),
      brand: brands(:elephant),
      store: stores(:elephant),
      date: Date.today,
      sale: false,
      price: 0.99
    )
    assert price.valid?
  end

  test "requires a price, amount, store" do
    price = Price.new
    assert_not price.valid?
    assert_equal :blank, price.errors.where(:price).first.type
    assert_equal :blank, price.errors.where(:amount).first.type
    assert_equal :blank, price.errors.where(:store).first.type
  end
end
