class ProductBrand < ApplicationRecord
  has_many :products, foreign_key: "brand_id"

  validates :name, presence: true
  validates :name, uniqueness: true
end
