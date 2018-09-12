Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "dapps#index"

  resources :dapps, only: [:index]
  get 'info', to: 'dapps#info'
  get 'more', to: 'dapps#more'
  get 'mine', to: 'dapps#mine'
  get 'history', to: 'dapps#history'

  namespace :admin do
    resources :images
    resources :banners
    resources :dapps
  end

end
