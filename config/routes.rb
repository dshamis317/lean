Rails.application.routes.draw do
  get '/' => 'search#index', as: 'root'
  post '/' => 'search#search'
end
