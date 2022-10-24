Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               omniauth_callbacks: "users/omniauth_callbacks"
             }
  devise_scope :user do
    authenticated { root to: "posts#index" }
    unauthenticated { root to: "devise/sessions#new", as: :root_url }
  end
  resources :users, only: :index
  
  resources :posts do
    resources :comments
  end

  resources :friend_requests, only: %i[index create destroy]
  resources :friendships, only: %i[create destroy]
  get 'friends', to: 'friendships#index', as: :friends
  resources :likes, only: %i[create destroy]
  resource :profile
  resource :menu, controller: 'menu', only: :show
  scope ':username', constraints: { username: /[^\/]+/ } do
    resources :notifications, only: %i[index create update destroy] do
      patch :read_all, on: :collection
      delete :clear_all_loaded, on: :collection
    end
  end
  get ':username', to: 'users#show', constraints: { username: /[^\/]+/ }, as: :user

  get "posts/:post_id/comments/minimize",
      to: "comments#minimize",
      as: :minimize_comments
end
