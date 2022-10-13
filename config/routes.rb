Rails.application.routes.draw do
  post '/users/sign-up', to: 'users#sign_up'
end
