Rails.application.routes.draw do
  get 'top/index'
  
  post  '/callback' => 'webhook#callback'

  root 'top#index'
end
