Rails.application.routes.draw do

  resources :meats
  resources :top, :only => [:index]

  post  '/callback' => 'webhook#callback'

  root 'top#index'
end
