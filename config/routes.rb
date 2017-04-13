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
  resources :users

  resources :tournaments

  resources :stocks do
    resources :tournaments
  end
 
  resources :holdings
 
  get "application/show_stock_modal"
  get "application/show_user_modal"
  get "application/show_news_modal"
  get "application/show_post_modal"


  resources :home

  get "/refresh" => 'holdings#refresh', as: 'refresh'

  resources :posts
end
