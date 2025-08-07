Rails.application.routes.draw do
  namespace :api do
    resources :todolists, controller: 'todo_lists', only: [:index, :show, :create, :update, :destroy] do
      resources :todo_list_items, controller: 'todo_list_items', only: [:index, :show, :create, :update, :destroy]
    end
  end

  resources :todo_lists, only: %i[index new], path: :todolists
end
