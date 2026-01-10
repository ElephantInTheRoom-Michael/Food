require "test_helper"

class IngredientTest < ActiveSupport::TestCase
  test "should save a basic ingredient" do
    ingredient = Ingredient.new(name: "test ingredient")
    assert ingredient.save
    assert_equal Ingredient.find(ingredient.id), ingredient
  end

  test "should not save without a name" do
    ingredient = Ingredient.new
    assert_not ingredient.save
    assert_equal :name, ingredient.errors.first.attribute
    assert_equal :blank, ingredient.errors.first.type
  end
end
