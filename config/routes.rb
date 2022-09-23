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
    resources :comments, only: %i[index new create]
  end

  resources :friends, only: :index
  resources :friend_requests, only: %i[index create destroy]
  resources :friendships, only: %i[create destroy]
  resources :likes, only: %i[create destroy]
  resource :profile
  get ':username', to: 'users#show', constraints: { username: /[^\/]+/ }, as: :user

  get "posts/:post_id/comments/minimize",
      to: "comments#minimize",
      as: :minimize_comments
end
