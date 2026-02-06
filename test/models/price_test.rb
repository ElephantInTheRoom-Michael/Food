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
    assert price.save
  end

  test "requires a price, amount, store, date" do
    price = Price.new
    assert_not price.valid?
    check_model_has_error(price, :price, :blank)
    check_model_has_error(price, :amount, :blank)
    check_model_has_error(price, :store, :blank)
    check_model_has_error(price, :date, :blank)
  end
end
