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
  resources :users, only: [:index, :show]
  resources :posts do
    resources :comments, only: [:index, :new, :create]
  end

  resources :friends, only: [:index, :show]
  resources :friend_requests, only: [:create, :destroy]
  resources :friendships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
  resource :profile
  
  get 'posts/:post_id/comments/minimize', to: 'comments#minimize', as: :minimize_comments
end
