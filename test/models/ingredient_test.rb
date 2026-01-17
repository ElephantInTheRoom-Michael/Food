require "test_helper"

class IngredientTest < ActiveSupport::TestCase
  test "should save a basic ingredient" do
    ingredient = Ingredient.new(name: "test ingredient")
    assert ingredient.save
    assert_equal Ingredient.find(ingredient.id), ingredient
  end

  test "should not save without a name" do
    ingredient = Ingredient.new
    assert_not ingredient.valid?
    check_model_has_error(ingredient, :name, :blank)
  end
end
