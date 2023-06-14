Rails.application.routes.draw do
  namespace :users do
    post :sign_up, path: 'sign-up'
    post :sign_in, path: 'sign-in'
  end

  get '/taxi-requests', to: 'taxi_requests#index'
  post '/taxi-requests', to: 'taxi_requests#create'
  post '/taxi-requests/:id/accept', to: 'taxi_requests#accept'

  mount Coverband::Reporters::Web.new, at: '/coverage'
end
