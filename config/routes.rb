Rails.application.routes.draw do
  root 'updates#index'

  resource :signup, only: [:new, :create]
  get 'signup', to: redirect('/signup/new')

  resource :session, only: [:new, :create, :destroy]

  resources :users do
    resource :invitation, only: [:create]
    resource :activation, only: [:new, :create]
    resource :password_change, only: [:new, :create]
  end

  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :root_users, only: [:update]
  resources :companies, only: [:index, :show, :edit, :update, :destroy]

  resources :updates, only: [:index, :create]
end
