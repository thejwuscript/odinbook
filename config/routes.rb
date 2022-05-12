Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    authenticated do
      root to: 'posts#index'
    end
    unauthenticated do
      root to: 'devise/sessions#new', as: :root_url
    end
  end
  resources :posts
  resources :friends, only: [:index, :show]
  resources :friend_requests
end
