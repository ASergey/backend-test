Rails.application.routes.draw do
  namespace :api do
    defaults format: :json do
      namespace :v1 do
        get 'publishers/:id/shops', to: 'publishers/shops#index', as: 'publisher_shops'

        # resources :shops do
        #   resources :books_in_shop
        # end
      end
    end
  end
end
