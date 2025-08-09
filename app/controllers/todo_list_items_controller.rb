class TodoListItemsController < ApplicationController
  before_action :set_todo_list
  before_action :set_todo_list_item, only: [:update]

  def create
    @todo_list_item = @todo_list.todo_list_items.new(todo_list_item_params)

    if @todo_list_item.save
      redirect_to @todo_list, notice: "Task created successfully."
    else
      redirect_to @todo_list, alert: @todo_list_item.errors.full_messages.to_sentence
    end
  end

  def update
    if @todo_list_item.update(todo_list_item_params)
      redirect_to @todo_list, notice: "Task updated successfully."
    else
      redirect_to @todo_list, alert: @todo_list_item.errors.full_messages.to_sentence
    end
  end

  def destroy
    @todo_list = TodoList.find(params[:todo_list_id])
    @todo_list_item = @todo_list.todo_list_items.find(params[:id])
    @todo_list_item.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to todo_list_path(@todo_list), notice: "Task deleted." }
    end
  end

  private

  def set_todo_list
    @todo_list = TodoList.find(params[:todo_list_id])
  end

  def set_todo_list_item
    @todo_list_item = @todo_list.todo_list_items.find(params[:id])
  end

  def todo_list_item_params
    params.require(:todo_list_item).permit(:title, :completed)
  end
end
