class AddPrecisionAndScaleToAmounts < ActiveRecord::Migration[8.1]
  def change
    change_column :amounts, :serving, :decimal, precision: 7, scale: 3
    change_column :amounts, :volume, :decimal, precision: 7, scale: 3
    change_column :amounts, :weight, :decimal, precision: 7, scale: 3
  end
end
