class CompleteAllTodoListItemsJob < ApplicationJob
  queue_as :default

  def perform(todo_list_id)
    todo_list = TodoList.find_by(id: todo_list_id)
    return unless todo_list

    todo_list.complete_all_items!

    puts "Broadcasting to: todo_list_#{todo_list.id}_items, locals: { todo_list: #{todo_list.to_s}, todo_list_items: #{todo_list.todo_list_items.to_s}"

    # Broadcast Turbo Stream update for this todo list's items
    Turbo::StreamsChannel.broadcast_replace_to(
      "todo_list_#{todo_list.id}_items",
      target: "todo_list_items",
      partial: "todo_list_items/todo_list_items",
      locals: { todo_list: todo_list, todo_list_items: todo_list.todo_list_items }
    )
  end
end
