module Api
  class TodoListItemsController < ApplicationController
    before_action :set_todo_list
    before_action :set_todo_list_item, only: [:show, :update, :destroy]

    def index
      render json: @todo_list.todo_list_items.select(:id, :title, :completed), status: :ok
    end

    def show
      render json: @todo_list_item.slice(:id, :title, :completed), status: :ok
    end

    def create
      item = @todo_list.todo_list_items.new(todo_list_item_params)
      if item.save
        render json: item.slice(:id, :title, :completed), status: :created
      else
        render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @todo_list_item.update(todo_list_item_params)
        render json: @todo_list_item.slice(:id, :title, :completed), status: :ok
      else
        render json: { errors: @todo_list_item.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @todo_list_item.destroy
      head :no_content
    end

    private

    def set_todo_list
      @todo_list = TodoList.find_by(id: params[:todolist_id])
      render json: { error: "TodoList not found" }, status: :not_found unless @todo_list
    end

    def set_todo_list_item
      @todo_list_item = @todo_list.todo_list_items.find_by(id: params[:id])
      render json: { error: "TodoListItem not found" }, status: :not_found unless @todo_list_item
    end

    def todo_list_item_params
      params.permit(:title, :completed)
    end
  end
end
