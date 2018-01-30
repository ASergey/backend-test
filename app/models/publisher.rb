class Publisher < ApplicationRecord
  has_many :books
  has_many :shops, through: :books

  def shops_with_books
    shops.select(
      'shops.*, SUM(books_in_shops.sold_count) as books_sold_count, ' + 
      'books.title, books.id as book_id, SUM(books_in_shops.in_stock) as in_stock'
    ).where('books_in_shops.in_stock > 0').group('books.id', 'shops.id')
  end
end
