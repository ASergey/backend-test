Rails.application.routes.draw do
  namespace :api do
    defaults format: :json do
      namespace :v1 do
        get 'publishers/:id/shops',          to: 'publishers/shops#index', as: 'publisher_shops'
        put 'shops/:id/books/:book_id/sell', to: 'shops/books#sell',       as: 'shop_book'
      end
    end
  end
end
