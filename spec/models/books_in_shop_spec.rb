require 'rails_helper'

RSpec.describe BooksInShop, type: :model do
  let(:book_in_shop) { build(:books_in_shop, sold_count: 5, in_stock: 5) }

  it 'method sell_book should change in_stock and sold_count amount' do
    book_in_shop.sell_book(2)
    expect(book_in_shop.sold_count).to eq(7)
    expect(book_in_shop.in_stock).to eq(3)
  end

  it 'should not allow in_stock less than 0 values' do
    book_in_shop.sell_book(6)
    book_in_shop.valid?

    expect(book_in_shop).to_not be_valid
    expect(book_in_shop.errors[:in_stock]).to include('not enough book copies')
  end
end
