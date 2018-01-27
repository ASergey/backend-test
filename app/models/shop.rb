class Shop < ApplicationRecord
  has_many :books_in_shop
  has_many :books, through: :books_in_shop

  accepts_nested_attributes_for :books_in_shop
end
