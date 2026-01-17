require "test_helper"

class StoreTest < ActiveSupport::TestCase
  test "should save a store with a name" do
    store = Store.new(name: "test")
    assert store.save
  end

  test "requires a name" do
    store = Store.new
    assert_not store.valid?
    check_model_has_error(store, :name, :blank)
  end
end
