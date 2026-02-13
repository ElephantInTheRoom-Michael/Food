require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  test "create a new recipe with a name" do
    recipe = Recipe.new(name: "test")
    assert recipe.save
  end

  test "requires a name" do
    recipe = Recipe.new
    assert_not recipe.valid?
    check_model_has_error(recipe, :name, :blank)
  end

  test "can add amounts of ingredients" do
    recipe = Recipe.new(name: "test")
    recipe.amounts.append(amounts(:one_onion))
    assert recipe.valid?
  end
end
