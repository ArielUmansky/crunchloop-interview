class CompleteAllTodoListItemsJob < ApplicationJob
  queue_as :default

  def perform(todo_list_id)
    todo_list = TodoList.find_by(id: todo_list_id)
    return unless todo_list

    todo_list.todo_list_items.where(completed: false).update_all(completed: true)
  end
end