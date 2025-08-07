class TodoListItem < ApplicationRecord
  belongs_to :todo_list
  validates :title, presence: true
  attribute :completed, :boolean, default: false
end
