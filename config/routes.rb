Rails.application.routes.draw do
  root 'updates#index'
  get 'signup', to: redirect('/signup/new')

  resource :session, only: [:new, :create, :destroy]
  resource :signup, only: [:new, :create]

  resources :companies, only: [:index, :show, :edit, :update, :destroy]
  resources :updates, only: [:index, :create]

  resources :users do
    resource :invitation, only: [:create]
    resource :activation, only: [:new, :create]
    resource :password_change, only: [:new, :create]
  end

  # group under users?
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :root_users, only: [:update]
end
