Rails.application.routes.draw do
  get '/' => 'search#index', as: 'root'
  post '/' => 'search#search'
  post '/history/:topic_id/:search_term' => 'search#save'
  get '/ticker' => 'search#ticker'
end
