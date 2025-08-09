require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :api do
    resources :todolists, controller: 'todo_lists', only: [:index, :show, :create, :update, :destroy] do
      member do
        post :complete_all
      end
      resources :todo_list_items, controller: 'todo_list_items', only: [:index, :show, :create, :update, :destroy]
    end

  end

  resources :todo_lists, path: 'todolists', only: [:index, :show, :new, :create] do
    member do
      post :complete_all
    end
    resources :todo_list_items, only: [:create, :update]
  end
  
  mount Sidekiq::Web => '/sidekiq'

end
