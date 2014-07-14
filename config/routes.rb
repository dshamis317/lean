Rails.application.routes.draw do
  get '/' => 'search#index', as: 'root'
  post '/' => 'search#search'

  get '/login' => 'sessions#new', as: 'login'
  post '/sessions' => 'sessions#create', as: 'sessions'
  delete '/logout' => 'sessions#destroy', as: 'logout'

  get '/signup' => 'users#new', as: 'signup'
  post '/users' => 'users#create', as: 'users'
  get '/profile/:id' => 'users#profile', as: 'profile'
end
