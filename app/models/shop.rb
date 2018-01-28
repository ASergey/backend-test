class Shop < ApplicationRecord
  has_many :books_in_shop
  has_many :books, through: :books_in_shop

  accepts_nested_attributes_for :books_in_shop

  def self.with_books
    select(
      'shops.*, SUM(books_in_shops.sold_count) as books_sold_count, ' + 
      'books.title, books.id as book_id, SUM(books_in_shops.in_stock) as in_stock'
    )
    .group('books.id', 'shops.id')
  end
end
