class Store < ApplicationRecord
  validates :name, presence: true

  has_many :prices

  accepts_nested_attributes_for :prices, reject_if: ->(attributes) { attributes[:price].blank? }
end
