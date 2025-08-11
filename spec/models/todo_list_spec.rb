# spec/models/todo_list_spec.rb
require 'rails_helper'

RSpec.describe TodoList, type: :model do
  let!(:todo_list) { TodoList.create!(name: "Sample List") }
  let!(:item1) { todo_list.todo_list_items.create!(title: "Task 1", completed: false) }
  let!(:item2) { todo_list.todo_list_items.create!(title: "Task 2", completed: false) }
  let!(:completed_item) { todo_list.todo_list_items.create!(title: "Task 3", completed: true) }


  describe 'validations' do

    subject do
      described_class.new(name: 'Groceries')
    end
    
    it 'is valid with a unique name' do
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid with a duplicate name (case insensitive)' do
      described_class.create!(name: 'Groceries')
      subject.name = 'groceries'
      expect(subject).not_to be_valid
    end
  end

  describe "#complete_all_items!" do
    subject do
      todo_list.complete_all_items!
    end

    it "marks all incomplete todo list items as completed" do
      subject

      todo_list.todo_list_items.each do |item|
        expect(item.reload.completed).to eq(true)
      end
    end

    it "does not change already completed items" do
      subject

      expect(completed_item.reload.completed).to eq(true)
    end
  end
end
