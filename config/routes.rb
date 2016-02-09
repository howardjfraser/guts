Rails.application.routes.draw do

  root 'sessions#new'

  resources :signups, only: [:new, :create]

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :companies, except: [:new, :create] do
    member do
      post "select" => "companies#select"
    end
  end

  resources :users
  resources :activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

end
