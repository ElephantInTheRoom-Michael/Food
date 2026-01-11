class Conversion < ApplicationRecord
  belongs_to :ingredient
  belongs_to :volume_unit, optional: true
  belongs_to :weight_unit, optional: true
end
