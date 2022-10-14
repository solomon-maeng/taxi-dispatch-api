Rails.application.routes.draw do
  namespace :users do
    post :sign_up, path: 'sign-up'
    post :sign_in, path: 'sign-in'
  end

  get '/taxi-requests', to: 'taxi_requests#index'
end
