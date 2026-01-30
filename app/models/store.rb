class Store < ApplicationRecord
  validates :name, presence: true

  has_many :prices
end
