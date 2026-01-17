require "test_helper"

class StoreTest < ActiveSupport::TestCase
  test "requires a name" do
    store = Store.new
    assert_not store.valid?
    assert_equal :blank, store.errors.where(:name).first.type
  end
end
