Rails.application.routes.draw do
  root 'updates#index'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :signups, only: [:index, :new, :create]

  resources :companies, except: [:new, :create] do
    member do
      post 'select' => 'companies#select'
    end
  end

  resources :users

  resources :activations, only: [:edit, :update]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :password_changes, only: [:edit, :update]

  post 'invitations/resend/:id' => 'invitations#resend', as: 'resend_invitation'

  resources :updates, only: [:index, :create]
end
