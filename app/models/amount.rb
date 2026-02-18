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
      "#{number_label(volume)} #{volume_unit.name} #{ingredient.name}".squish
    elsif weight.present?
      "#{number_label(weight)} #{weight_unit.name} #{ingredient.name}".squish
    else
      ingredient_name = serving == 0 || serving > 1 ? ingredient.name.pluralize : ingredient.name
      "#{number_label(serving)} #{serving_variant} #{ingredient_name}".squish
    end
  end

  private

  # @param [BigDecimal, nil] n
  def number_label(n)
    return "0" if n.nil?

    fracs = {
      2 => 0,
      3 => 0.001,
      4 => 0,
      5 => 0,
      6 => 0.001,
      8 => 0,
      10 => 0,
      12 => 0.001,
      16 => 0.001,
    }.map do |denom, threshold|
      f = n.frac.to_r.rationalize(threshold)
      f.denominator == denom ? f : nil
    end.compact
    frac = fracs.empty? ? nil : fracs.first

    case [ n, frac ]
    in [ BigDecimal => bd, nil ] if bd.frac == 0
      "#{bd.to_i}"
    in [ BigDecimal => bd, nil ]
      "#{bd}"
    in [ BigDecimal => bd, Rational => f ] if bd < 1
      "#{f}"
    in [ BigDecimal => bd, Rational => f ]
      "#{bd.to_i} & #{f}"
    else
      "#{n}"
    end
  end
end
