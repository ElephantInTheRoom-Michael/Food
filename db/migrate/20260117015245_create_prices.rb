class CreatePrices < ActiveRecord::Migration[8.1]
  def change
    create_table :amounts do |t|
      t.references :ingredient, index: true, foreign_key: true
      t.decimal :serving
      t.string :serving_variant
      t.decimal :volume
      t.references :volume_unit, index: true, foreign_key: true
      t.string :volume_variant
      t.decimal :weight
      t.references :weight_unit, index: true, foreign_key: true

      t.timestamps
    end

    create_table :brands do |t|
      t.string :name

      t.timestamps
    end

    create_table :stores do |t|
      t.string :name

      t.timestamps
    end

    create_table :prices do |t|
      t.text :description
      t.references :amount, index: true, foreign_key: true
      t.references :brand, index: true, foreign_key: true
      t.references :store, index: true, foreign_key: true
      t.date :date
      t.boolean :sale
      t.decimal :price

      t.timestamps
    end
  end
end
