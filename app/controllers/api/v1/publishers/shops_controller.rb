class Api::V1::Publishers::ShopsController < ApplicationController
  def index
    books_in_shops = Publisher.find(params[:id]).shops.with_books
    render json: { shops: prepare_view(books_in_shops) }
  end

  private

  def prepare_view(books_in_shops)
    shops = []
    books_in_shops.group_by(&:id).each do |shop_id, shop_with_books|
      shops << {
        id:               shop_id,
        name:             shop_with_books.first.name,
        books_sold_count: shop_with_books.map(&:books_sold_count).sum,
        books_in_stock:   shop_with_books.map do |book|
          { id: book.book_id, title: book.title, copies_in_stock: book.in_stock }
        end
      }
    end

    shops
  end
end
