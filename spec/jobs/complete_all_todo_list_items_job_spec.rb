require 'rails_helper'

RSpec.describe CompleteAllTodoListItemsJob, type: :job do
  let!(:todo_list) { TodoList.create!(name: "My List") }
  let!(:item1) { todo_list.todo_list_items.create!(title: "Task 1", completed: false) }
  let!(:item2) { todo_list.todo_list_items.create!(title: "Task 2", completed: false) }
  let(:todo_list_param) { todo_list.id }

  # This will run the job immediately
  subject do
    described_class.perform_now(todo_list_param)
  end

  it "marks all todo list items as completed" do
    subject

    todo_list.todo_list_items.each do |item|
      expect(item.reload.completed).to eq(true)
    end
  end

  context "when the todo list does not exist" do
    let(:todo_list_param) { 99999 }

    it "does not raise an error" do
      expect { subject }.not_to raise_error
    end
  end

end