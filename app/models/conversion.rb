class Conversion < ApplicationRecord
  belongs_to :ingredient
  belongs_to :volume_unit, optional: true
  belongs_to :weight_unit, optional: true

  validates :serving, uniqueness: { scope: :ingredient_id }, allow_blank: true
  validates :volume, presence: true, if: :volume_unit_id?
  validates :volume, uniqueness: { scope: :ingredient_id }, allow_blank: true
  validates :volume_unit, presence: true, if: :volume
  validates :weight, presence: true, if: :weight_unit_id?
  validates :weight, uniqueness: { scope: :ingredient_id }, allow_blank: true
  validates :weight_unit, presence: true, if: :weight
  validate :has_conversion

  def has_conversion
    conversions = 0
    conversions += 1 if volume
    conversions += 1 if weight
    conversions += 1 if serving
    if conversions < 2
      errors.add :base, :missing_conversion, message: "must have at least two values set out of volume, weight, or serving"
    end
  end
end
