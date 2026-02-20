require "test_helper"

class AmountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @amount = amounts(:one_onion)
  end

  test "should get index" do
    get amounts_url
    assert_response :success
  end

  test "should get new" do
    get new_amount_url
    assert_response :success
  end

  test "should create amount" do
    assert_difference("Amount.count") do
      post amounts_url, params: {
        amount: {
          ingredient_id: @amount.ingredient.id,
          serving: @amount.serving + 1.0,
        },
      }
    end

    assert_redirected_to amount_url(Amount.last)
  end

  test "should show amount" do
    get amount_url(@amount)
    assert_response :success
  end

  test "should get edit" do
    get edit_amount_url(@amount)
    assert_response :success
  end

  test "should update amount" do
    patch amount_url(@amount), params: { amount: { serving: @amount.serving, serving_variant: @amount.serving_variant, volume: @amount.volume, volume_variant: @amount.volume_variant, weight: @amount.weight } }
    assert_redirected_to amount_url(@amount)
  end

  # test "should destroy amount" do
  #   assert_difference("Amount.count", -1) do
  #     delete amount_url(@amount)
  #   end
  #
  #   assert_redirected_to amounts_url
  # end

  test "should expand some fractional values" do
    post amounts_url, params: {
      amount: {
        ingredient_id: @amount.ingredient.id,
        serving: "12.17",
      },
    }

    assert_equal BigDecimal(12.167), Amount.last&.serving

    post amounts_url, params: {
      amount: {
        ingredient_id: @amount.ingredient.id,
        weight: "0.34",
        weight_unit_id: weight_units(:gram).id,
      },
    }

    assert_equal BigDecimal(0.333), Amount.last&.weight

    post amounts_url, params: {
      amount: {
        ingredient_id: @amount.ingredient.id,
        volume: "100.66",
        volume_unit_id: volume_units(:liter).id,
      },
    }

    assert_equal BigDecimal(100.667), Amount.last&.volume
  end
end
