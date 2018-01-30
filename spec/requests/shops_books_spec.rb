require 'rails_helper'

RSpec.describe 'Shops Books API', type: :request do

  describe 'PUT /api/v1/shops/:id/books/:book_id/sell' do
    let(:book)         { create(:book) }
    let(:shop)         { create(:shop) }
    let(:amount)       { { amount: 10 } }

    context 'when the shop does not exist' do
      before { put "/api/v1/shops/-1/books/#{book.id}/sell" }

      it 'returns status code 404' do
        expect(response.status).to eq(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Shop with 'id'=-1/)
      end
    end

    context 'when the book does not exist' do
      before { put "/api/v1/shops/#{shop.id}/books/-2/sell" }

      it 'returns status code 404' do
        expect(response.status).to eq(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Book with 'id'=-2 in specified Shop/)
      end
    end

    context 'when the book exists' do
      before { put "/api/v1/shops/#{shop.id}/books/#{book.id}/sell", params: amount }

      context 'but not in specified shop' do
        let!(:book_in_shop) { create(:books_in_shop, book: book) }

        it 'returns status code 404' do
          expect(response.status).to eq(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Book with 'id'=#{book.id} in specified Shop/)
        end
      end

      context 'but request with unspecified amount' do
        let!(:book_in_shop) { create(:books_in_shop, shop: shop, book: book) }

        before { put "/api/v1/shops/#{shop.id}/books/#{book.id}/sell", params: { not_amount: 10 } }

        it 'returns unprocessable_entity status' do
          expect(response.status).to eq(422)
        end

        it 'returns validation failed message' do
          expect(response.body).to match(/'amount' to sell must be specified/)
        end
      end

      context 'with wrong amount' do
        let!(:book_in_shop) { create(:books_in_shop, shop: shop, book: book) }

        before { put "/api/v1/shops/#{shop.id}/books/#{book.id}/sell", params: { amount: -10 } }

        it 'returns unprocessable_entity status' do
          expect(response.status).to eq(422)
        end

        it 'returns validation failed message' do
          expect(response.body).to match(/'amount' must be 0 or greater/)
        end
      end

      context 'with too big amount' do
        let!(:book_in_shop) { create(:books_in_shop, shop: shop, book: book) }

        before { put "/api/v1/shops/#{shop.id}/books/#{book.id}/sell", params: { amount: 100 } }

        it 'returns unprocessable_entity status' do
          expect(response.status).to eq(422)
        end

        it 'returns validation failed message' do
          expect(response.body).to match(/Validation failed: In stock must be greater than or equal to 0/)
        end
      end

      context 'with 0 amount' do
        let!(:book_in_shop) { create(:books_in_shop, shop: shop, book: book, in_stock: 10) }

        before { put "/api/v1/shops/#{shop.id}/books/#{book.id}/sell", params: { amount: 0 } }

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'returns not changed books in shop attributes' do
          expect(json['shop_id']).to eq(shop.id)
          expect(json['book_id']).to eq(book.id)
          expect(json['in_stock']).to eq(book_in_shop.in_stock)
          expect(json['sold_count']).to eq(book_in_shop.sold_count)
        end
      end

      context 'with positive valid amount' do
        let!(:book_in_shop) { create(:books_in_shop, shop: shop, book: book, in_stock: 10) }

        before { put "/api/v1/shops/#{shop.id}/books/#{book.id}/sell", params: { amount: 8 } }

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'returns updated books in shop attributes' do
          expect(json['shop_id']).to eq(shop.id)
          expect(json['book_id']).to eq(book.id)
          expect(json['in_stock']).to eq(book_in_shop.in_stock - 8)
          expect(json['sold_count']).to eq(book_in_shop.sold_count + 8)
        end
      end
    end
  end
end
