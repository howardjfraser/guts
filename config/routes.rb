Rails.application.routes.draw do
  root 'updates#index'

  resource :session, only: [:new, :create, :destroy]
  resource :signup, only: [:new, :create]

  resources :activations, only: [:edit, :update]
  resources :companies, only: [:index, :show, :edit, :update, :destroy]
  resources :password_changes, only: [:edit, :update]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :root_users, only: [:update]
  resources :updates, only: [:index, :create]
  resources :users

  # TODO: use resources?
  post 'invitations/resend/:id' => 'invitations#resend', as: 'resend_invitation'

  get 'signup', to: redirect('/signup/new')
end
