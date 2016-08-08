Rails.application.routes.draw do
  resources :todos

  get '/todos/find_by_category/:id', to: 'todos#find_by_category'
  get '/todos/find_by_user/:id', to: 'todos#find_by_user'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :categories

  resources :users

  get '/users/login/:id', to: 'users#login'
end
