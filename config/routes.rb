Rails.application.routes.draw do
  root 'updates#index'

  resources :signups, only: [:index, :new, :create]
  resource :session, only: [:new, :create, :destroy]

  resources :companies, except: [:new, :create] do
    member do
      # TODO: use resources?
      post 'select' => 'companies#select'
    end
  end

  resources :users

  resources :activations, only: [:edit, :update]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :password_changes, only: [:edit, :update]

  # TODO: use resources?
  post 'invitations/resend/:id' => 'invitations#resend', as: 'resend_invitation'

  resources :updates, only: [:index, :create]
end
