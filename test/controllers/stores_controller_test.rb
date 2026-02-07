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
    initial_price = @store.prices.first.price

    patch shopping_trip_store_url(@store), params: {
      store: {
        name: @store.name,
        date: Date.today,
        prices_attributes: {
          0 => { amount_id: amounts(:one_onion).id, price: 10 },
          1 => {},
        },
      },
    }
    assert_redirected_to store_url(@store)

    assert_equal 10, @store.prices.last.price

    # Verify existing price wasn't deleted
    assert_equal initial_price, @store.prices.first.price
  end

  test "should create a new brand if requested from a shopping trip" do
    patch shopping_trip_store_url(@store), params: {
      store: {
        name: @store.name,
        date: Date.today,
        prices_attributes: {
          0 => {
            amount_id: amounts(:one_onion).id, price: 10,
            new_brand: 0, brand_id: brands(:elephant).id,
          },
          1 => {
            amount_id: amounts(:one_onion).id, price: 10,
            new_brand: 1, brand_id: brands(:elephant).id, brand_attributes: { name: "New Brand" }, },
        },
      },
    }
    assert_redirected_to store_url(@store)

    assert_equal brands(:elephant), Price.second_to_last&.brand
    assert_equal "New Brand", Price.last&.brand&.name
  end
end
