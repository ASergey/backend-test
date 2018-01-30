require 'rails_helper'

RSpec.describe 'Publishers Shops API', type: :request do
  describe 'GET /api/v1/publishers/:id/shops' do
    let(:publisher) { create(:publisher) }
    let(:shop)      { create(:shop) }

    before { get "/api/v1/publishers/#{publisher.id}/shops" }

    context 'when the publisher does not exist' do
      before { get "/api/v1/publishers/-1/shops" }

      it 'returns status code 404' do
        expect(response.status).to eq(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Publisher with 'id'=-1/)
      end
    end

    context 'when the publisher exists without books' do
      it 'returns empty shops' do
        expect(json).not_to be_empty
        expect(json['shops']).to be_empty
        expect(json['shops']).to eq([])
      end

      it 'responds with a 200 status' do
        expect(response.status).to eq 200
      end
    end

    context 'when the publisher exists without books in shop' do
      let(:book) { create(:book, publisher: publisher) }

      it 'returns empty shops' do
        expect(json).not_to be_empty
        expect(json['shops']).to be_empty
        expect(json['shops']).to eq([])
      end

      it 'responds with a 200 status' do
        expect(response.status).to eq 200
      end
    end

    context 'when the publisher has sold out all his books in shop' do
      let(:book)            { create(:book, publisher: publisher) }
      let(:books_in_shop)   { create(:books_in_shop, shop: shop) }
      let(:books_in_shop_0) { create(:books_in_shop, book: book, shop: shop, in_stock: 0) }

      it 'returns empty shops' do
        expect(json).not_to be_empty
        expect(json['shops']).to be_empty
        expect(json['shops']).to eq([])
      end

      it 'responds with a 200 status' do
        expect(response.status).to eq 200
      end
    end

    context 'when the publisher has shops with books' do
      let!(:book)            { create(:book, publisher: publisher) }
      let!(:book_2)          { create(:book, publisher: publisher) }
      let!(:book_3)          { create(:book, publisher: publisher) }

      let!(:books_in_shop)   { create(:books_in_shop, shop: shop) }
      let!(:books_in_shop_0) { create(:books_in_shop, book: book, shop: shop, in_stock: 0) }
      let!(:books_in_shop_2) { create(:books_in_shop, book: book_2, shop: shop, sold_count: 2, in_stock: 2) }
      let!(:books_in_shop_3) { create(:books_in_shop, book: book_3, shop: shop, sold_count: 1, in_stock: 5) }

      let!(:books_another_shop) { create(:books_in_shop, book: book, sold_count: 5, in_stock: 3) }

      before { get "/api/v1/publishers/#{publisher.id}/shops" }

      it 'returns not empty shops' do
        expect(json).not_to be_empty
        expect(json['shops']).not_to be_empty
      end

      it 'returns shops ordered by books sold' do
        expect(json['shops'].size).to eq(2)

        shop_1 = json['shops'].first
        expect(shop_1['name']).to eq(books_another_shop.shop.name)
        expect(shop_1['books_sold_count']).to eq(5)

        shop_2 = json['shops'].last
        expect(shop_2['id']).to eq(shop.id)
        expect(shop_2['name']).to eq(shop.name)
        expect(shop_2['books_sold_count']).to eq(3)
      end

      it 'returns books with shops' do
        shop_1_books = json['shops'].first['books_in_stock']

        expect(shop_1_books.size).to eq(1)
        expect(shop_1_books.first['id']).to eq(book.id)
        expect(shop_1_books.first['title']).to eq(book.title)
        expect(shop_1_books.first['copies_in_stock']).to eq(books_another_shop.in_stock)

        shop_2_books = json['shops'].last['books_in_stock']
        expect(shop_2_books.size).to eq(2)
        expect(shop_2_books.map { |sb| sb['id'] }).to include(book_2.id, book_3.id)
        expect(shop_2_books.map { |sb| sb['title'] }).to include(book_2.title, book_3.title)
        expect(shop_2_books.map { |sb| sb['copies_in_stock'] }).to include(books_in_shop_2.in_stock, books_in_shop_3.in_stock)
      end

      it 'responds with a 200 status' do
        expect(response.status).to eq 200
      end
    end
  end
end
