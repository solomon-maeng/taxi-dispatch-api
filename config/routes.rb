Rails.application.routes.draw do
  namespace :users do
    post :sign_up, path: 'sign-up'
    post :sign_in, path: 'sign-in'
    get :me, path: 'me'
  end

  get '/taxi-requests', to: 'taxi_requests#index'
  post '/taxi-requests', to: 'taxi_requests#create'
end
