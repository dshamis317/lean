Rails.application.routes.draw do
  get '/' => 'search#index'
  post '/' => 'search#search'
end
