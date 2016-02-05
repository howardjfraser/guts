Rails.application.routes.draw do

  root 'sessions#new'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get 'signup' => 'signups#new'
  post 'signup' => 'signups#create'

  resources :companies, except: [:new, :create] do
    member do
      post "select" => "companies#select"
    end
  end

  resources :users
  resources :activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

end
