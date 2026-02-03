class Amount < ApplicationRecord
  belongs_to :ingredient
  belongs_to :volume_unit, optional: true
  belongs_to :weight_unit, optional: true

  validates :serving, absence: true, unless: -> { volume.blank? && weight.blank? }
  validates :serving, uniqueness: { scope: :ingredient_id }, allow_blank: true
  validates :volume, absence: true, unless: -> { serving.blank? && weight.blank? }
  validates :volume, presence: true, if: :volume_unit_id?
  validates :volume, uniqueness: { scope: :ingredient_id }, allow_blank: true
  validates :volume_unit, presence: true, if: :volume
  validates :weight, absence: true, unless: -> { serving.blank? && volume.blank? }
  validates :weight, presence: true, if: :weight_unit_id?
  validates :weight, uniqueness: { scope: :ingredient_id }, allow_blank: true
  validates :weight_unit, presence: true, if: :weight
  validate do
    if serving.blank? && volume.blank? && weight.blank?
      errors.add :base, :blank
    end
  end

  def label
    if volume.present?
      "#{volume} #{volume_unit.name} #{ingredient.name}"
    elsif weight.present?
      "#{weight} #{weight_unit.name} #{ingredient.name}"
    else
      "#{serving} #{serving_variant} #{ingredient.name}"
    end
  end
end
