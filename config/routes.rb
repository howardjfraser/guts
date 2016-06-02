Rails.application.routes.draw do
  root 'updates#index'
  get 'signup', to: redirect('/signup/new')

  resource :session, only: [:new, :create, :destroy]
  resource :signup, only: [:new, :create]

  resources :companies, only: [:index, :show, :edit, :update, :destroy]
  resources :updates, only: [:index, :create]
  resources :users

  # group under users?
  resources :activations, only: [:edit, :update]
  resources :password_changes, only: [:edit, :update]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :root_users, only: [:update]

  # TODO: use resources?
  post 'invitations/resend/:id' => 'invitations#resend', as: 'resend_invitation'
end
