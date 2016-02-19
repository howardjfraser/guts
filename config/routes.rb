Rails.application.routes.draw do

  root 'sessions#new'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :signups, only: [:new, :create]

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

end
