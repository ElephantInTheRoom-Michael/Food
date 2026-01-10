require "test_helper"

class IngredientsControllerTest < ActionDispatch::IntegrationTest
  test "should get all" do
    get ingredients_url
    assert_response :success
    assert_equal "application/json", @response.media_type
    assert_equal Ingredient.count, JSON.parse(@response.body).length
  end
end
