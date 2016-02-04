Rails.application.routes.draw do

  root 'sessions#new'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get 'signup' => 'companies#new'
  resources :companies, only: [:index, :show, :create, :edit]

  resources :users
  resources :activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

end
