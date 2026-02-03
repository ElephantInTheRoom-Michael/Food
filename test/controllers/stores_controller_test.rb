require "test_helper"

class StoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @store = stores(:elephant)
  end

  test "should get index" do
    get stores_url
    assert_response :success
  end

  test "should get new" do
    get new_store_url
    assert_response :success
  end

  test "should create store" do
    assert_difference("Store.count") do
      post stores_url, params: { store: { name: @store.name } }
    end

    assert_redirected_to store_url(Store.last)
  end

  test "should show store" do
    get store_url(@store)
    assert_response :success
  end

  test "should get edit" do
    get edit_store_url(@store)
    assert_response :success
  end

  test "should update store" do
    patch store_url(@store), params: { store: { name: @store.name } }
    assert_redirected_to store_url(@store)
  end

  # test "should destroy store" do
  #   assert_difference("Store.count", -1) do
  #     delete store_url(@store)
  #   end
  #
  #   assert_redirected_to stores_url
  # end

  test "should get shopping trip" do
    get shopping_trip_store_url(@store)
    assert_response :success
  end

  test "should update with a shopping trip" do
    patch store_url(@store), params: {
      store: {
        name: @store.name,
      },
      prices_attributes: [
        { ingredient_id: ingredients(:onion).id, amount: 1, price: 10 }
      ]
    }
    puts @response.body
    assert_redirected_to store_url(@store)
    puts Price.last.inspect
  end
end
