class Api::V1::Shops::BooksController < ApplicationController
  def sell
    shop         = Shop.find(params[:id])
    book_in_shop = shop.books_in_shop.find_by(book_id: params[:book_id])

    raise ActiveRecord::RecordNotFound.new(
      "Couldn't find Book with 'id'=#{params[:book_id]} in specified Shop"
    ) if book_in_shop.blank?
    raise ValidationError.new("'amount' to sell must be specified") unless params[:amount].present?

    amount = params[:amount].to_i
    raise ValidationError.new("'amount' must be 0 or greater") if amount < 0

    book_in_shop.sell_book(amount)
    book_in_shop.save!

    render json: book_in_shop
  end
end
