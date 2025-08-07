class ChangeDefaultForCompletedInTodoListItems < ActiveRecord::Migration[7.0]
  def change
    change_column_default :todo_list_items, :completed, from: nil, to: false
    change_column_null :todo_list_items, :completed, false
  end
end
