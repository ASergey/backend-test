class BooksInShop < ApplicationRecord
  belongs_to :book
  belongs_to :shop

  validates :in_stock, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def sell_book(amount)
    self.in_stock   -= amount
    self.sold_count += amount
  end
end
