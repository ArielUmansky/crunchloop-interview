module Api
  class TodoListsController < ApplicationController
    before_action :set_todo_list, only: [:show, :update, :destroy]

    def index
      @todo_lists = TodoList.all
      render json: @todo_lists.as_json(methods: :progress, only: [:id, :name]), status: :ok
    end

    def show
      render json: @todo_list.as_json(methods: :progress, only: [:id, :name]), status: :ok
    end

    def create
      @todo_list = TodoList.new(todo_list_params)
      if @todo_list.save
        render json: @todo_list.as_json(methods: :progress, only: [:id, :name]), status: :created
      else
        render json: { errors: @todo_list.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @todo_list.update(todo_list_params)
        render json: @todo_list.as_json(methods: :progress, only: [:id, :name]), status: :ok
      else
        render json: { errors: @todo_list.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @todo_list.destroy
      head :no_content
    end

    def complete_all
      todo_list = TodoList.find_by(id: params[:id])
      if todo_list
        CompleteAllTodoListItemsJob.perform_later(todo_list.id)
        render json: { message: "Completing all items enqueued" }, status: :accepted
      else
        render json: { error: "TodoList not found" }, status: :not_found
      end
    end
    
    private

    def set_todo_list
      @todo_list = TodoList.find_by(id: params[:id])
      return render json: { error: 'Not Found' }, status: :not_found unless @todo_list
    end

    def todo_list_params
      params.permit(:name)
    end
  end
end
