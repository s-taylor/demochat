Demochat::Application.routes.draw do
  devise_for :users

  root 'home#index', :as => :home

  resources :rooms, :only => [:index,:create,:show]

  resources :messages, :only => [:create]

  #route for AJAX only to fetch new messages, MUST pass id of last message fetched
  get '/messages/fetch' => 'messages#fetch'

  #route fot AJAX only to inform server of user activity, MUST pass room id of current room (or -1 if none)
  post '/activity/user_active' => 'activity#userActive'
end
