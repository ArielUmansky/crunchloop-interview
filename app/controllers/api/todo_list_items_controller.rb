module Api
  class TodoListItemsController < ApplicationController
    before_action :set_todo_list
    before_action :set_todo_list_item, only: [:show, :update, :destroy]

    def index
      render json: @todo_list.todo_list_items.map { |item| item_json(item) }, status: :ok
    end

    def show
      render json: item_json(@todo_list_item), status: :ok
    end

    def create
      item = @todo_list.todo_list_items.new(mapped_todo_list_item_params)
      if item.save
        render json: item_json(item), status: :created
      else
        render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @todo_list_item.update(mapped_todo_list_item_params)
        render json: item_json(@todo_list_item), status: :ok
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
      params.permit(:title, :description, :completed)
    end

    def mapped_todo_list_item_params
      attrs = todo_list_item_params.to_h
      if attrs.key?("description")
        attrs["title"] = attrs.delete("description")
      end
      attrs
    end

    def item_json(item)
      {
        id: item.id,
        description: item.title,
        completed: item.completed
      }
    end
  end
end
