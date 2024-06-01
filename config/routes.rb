Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root :to =>"homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorite, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:index,:new,:show,:edit,:update] do
    resource :relationship, only: [:create, :destroy]
    get :follows, on: :member
    get :followers, on: :member
  end
  resources :messages, only: [:create]
  resources :rooms, only: [:create,:show]
end
