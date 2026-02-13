class CreateRecipes < ActiveRecord::Migration[8.1]
  def change
    create_table :recipes do |t|
      t.string :name

      t.timestamps
    end

    create_join_table :recipes, :amounts
  end
end
