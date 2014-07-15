Rails.application.routes.draw do
  get '/' => 'search#index', as: 'root'
  post '/' => 'search#search'
  get '/history' => 'search#history'
  post '/history' => 'search#save'
end
