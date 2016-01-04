Rails.application.routes.draw do

 root 'static_pages#home'

 # replace with new trial inc company name
 get 'signup' => 'users#new' # dupe

 get 'login' => 'sessions#new'
 post 'login' => 'sessions#create'
 delete 'logout' => 'sessions#destroy'

 resources :users
 resources :account_activations, only: [:edit]
 resources :password_resets, except: [:show, :destroy]

end
