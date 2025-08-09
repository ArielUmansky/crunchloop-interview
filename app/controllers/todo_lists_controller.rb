class TodoListsController < ApplicationController
  def index
    @todo_lists = TodoList.all
    respond_to :html
  end

  def new
    @todo_list = TodoList.new
    respond_to :html
  end

  def show
    @todo_list = TodoList.find(params[:id])
    @todo_list_items = @todo_list.todo_list_items.order(:created_at)
  end

  def create
    @todo_list = TodoList.new(todo_list_params)

    if @todo_list.save
      redirect_to todo_lists_path, notice: "Todo list created successfully"
    else
      @todo_lists = TodoList.all
      render :index, status: :unprocessable_entity
    end
  end

  def complete_all
    CompleteAllTodoListItemsJob.perform_later(params[:id])

    respond_to do |format|
      format.turbo_stream { head :accepted } # no immediate Turbo Stream response
      format.html { redirect_to todo_list_path(params[:id]), notice: "Task completion process started." }
    end
  end

  def destroy
    @todo_list = TodoList.find(params[:id])
    @todo_list.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to todo_lists_path, notice: "Todo list deleted." }
    end
  end

  private

  def todo_list_params
    params.permit(:name)
  end
end
