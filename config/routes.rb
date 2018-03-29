Rails.application.routes.draw do
  resources :chunks
  resources :records
  root to: 'client#main'
  get :admin, to: 'admin#main'
end
