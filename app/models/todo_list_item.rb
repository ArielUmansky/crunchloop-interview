class TodoListItem < ApplicationRecord
  belongs_to :todo_list
  validates :title, presence: true, uniqueness: { scope: :todo_list_id, case_sensitive: false }
  attribute :completed, :boolean, default: false
end
