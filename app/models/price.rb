class Price < ApplicationRecord
  belongs_to :amount
  belongs_to :store
  belongs_to :brand, optional: true

  validates :price, presence: true
  validates :date, presence: true

  accepts_nested_attributes_for :brand, reject_if: :all_blank
end
