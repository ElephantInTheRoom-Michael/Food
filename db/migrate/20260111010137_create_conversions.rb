class CreateConversions < ActiveRecord::Migration[8.1]
  def change
    create_table :volume_units do |t|
      t.string :name
      t.string :abbreviation

      t.timestamps
    end

    create_table :weight_units do |t|
      t.string :name
      t.string :abbreviation

      t.timestamps
    end

    create_table :conversions do |t|
      t.belongs_to :ingredient, index: true, foreign_key: true
      t.decimal :serving, precision: 6, scale: 2
      t.string :serving_variant
      t.decimal :volume, precision: 6, scale: 2
      t.references :volume_unit, index: true, foreign_key: true
      t.string :volume_variant
      t.decimal :weight, precision: 6, scale: 2
      t.references :weight_unit, index: true, foreign_key: true

      t.timestamps
    end
  end
end
