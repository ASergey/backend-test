class Book < ApplicationRecord
  has_many :books_in_shop
  has_many :shops, through: :books_in_shop
  belongs_to :publisher
end
