class TodoList < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :todo_list_items, dependent: :destroy

  def complete_all_items!
    todo_list_items.where(completed: false).update_all(completed: true)
  end

  def progress
    total = todo_list_items.count
    return 0 if total.zero?

    completed = todo_list_items.where(completed: true).count
    ((completed.to_f / total) * 100).round
  end
end