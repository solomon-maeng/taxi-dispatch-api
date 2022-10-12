Rails.application.routes.draw do
  post '/users/sign-up', to: 'users#sign_up'
  post '/users/sign-in', to: 'users#sign_in'
end
