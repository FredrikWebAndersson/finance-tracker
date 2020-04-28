Rails.application.routes.draw do
  get 'create/destroy'
  resources :user_stocks, only: [:create, :destroy]
  devise_for :users
  root "welcome#index"
  get "my_portfolio", to: "users#my_portfolio"
  get "search_stock", to: "stocks#search"
  get "friends", to: "users#friends"
  get "search_friend", to: "users#search"
  resources :friendships, only: [:create, :destroy]
end
