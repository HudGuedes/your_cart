require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products

  scope :carts do
    post '/', to: 'carts#add_product'
    get '/', to: 'carts#show_current'
    post '/add_item', to: 'carts#add_or_update_item'
    delete '/:product_id', to: 'carts#remove_item'
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "rails/health#show"
end
