Demochat::Application.routes.draw do
  
  devise_for :users

  root 'home#index', :as => :home

  #route for AJAX only to fetch new messages, MUST pass id of last message fetched
  get '/rooms/:id/fetch' => 'rooms#fetch'

  resources :rooms, :only => [:index,:create,:show]

  resources :messages, :only => [:create]

  #route fot AJAX only to inform server of user activity, MUST pass room id of current room (or -1 if none)
  post '/activity/user_active' => 'activity#userActive'

  resources :votes, :only => [:index,:create,:show,:destroy]

  resources :responses, :only => [:index,:create,:show,:destroy]
end
