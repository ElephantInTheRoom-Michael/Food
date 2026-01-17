class Price < ApplicationRecord
  belongs_to :amount
  belongs_to :store
  belongs_to :brand, optional: true

  validates :amount, presence: true
  validates :price, presence: true
  validates :store, presence: true
end
