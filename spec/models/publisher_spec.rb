require 'rails_helper'

RSpec.describe Publisher, type: :model do
  let!(:publisher)   { create(:publisher) }
  let!(:shop)        { create(:shop) }
  let!(:book)        { create(:book, publisher: publisher) }

  context 'publisher has no books' do
    it 'should not return any shop' do
      expect(create(:publisher).shops_with_books).to be_empty
    end
  end

  context 'publisher has book without shop' do
    it 'should not return any shop' do
      expect(publisher.shops_with_books).to be_empty
    end
  end

  context 'publisher has no books in the shops stock' do
    it 'should not return any shop' do
      create(:books_in_shop, shop: shop)
      create(:books_in_shop, book: book, shop: shop, in_stock: 0)

      expect(publisher.shops_with_books).to be_empty
    end
  end

  context 'publisher has books in shops' do
    let(:shop_2)  { create(:shop) }
    let(:book_2)  { create(:book, publisher: publisher) }

    it "should return shops with publisher's books" do
      create(:books_in_shop, book: book, shop: shop, in_stock: 5)
      create(:books_in_shop, book: book_2, shop: shop)
      create(:books_in_shop, book: book_2, shop: shop_2)

      expect(publisher.shops_with_books).not_to be_empty
      expect(publisher.shops_with_books).to contain_exactly(shop, shop, shop_2)
      expect(publisher.shops_with_books.first).to respond_to(:books_sold_count, :book_id, :title, :in_stock)
    end
  end
end
