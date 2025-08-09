class TodoList < ApplicationRecord
  validates :name, presence: true

  has_many :todo_list_items, dependent: :destroy

  def complete_all_items!
    todo_list_items.where(completed: false).update_all(completed: true)
  end
end