Rails.application.routes.draw do
  root 'static_pages#home'

  resources :stocks

  get 'holdings/new'

  get 'stocks/new'

  get 'sessions/new'

  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  resources :users do
    member do
      get :following, :followers
    end
  end


  resources :tournaments

  resources :stocks do
    resources :tournaments
  end
 
  resources :relationships, only: [:create, :destroy]

  resources :holdings
 
  get "application/show_stock_modal"
  get "application/show_user_modal"
  get "application/show_news_modal"
  get "application/show_post_modal"

  post "users/follow_user"
  post "users/unfollow_user"

  resources :home

  get "/refresh" => 'holdings#refresh', as: 'refresh'

  resources :posts

  resources :watchlists
  post "watchlists/new"
end
