require "rails_helper"

describe TodoListItem, type: :model do
  let(:todo_list) { TodoList.create!(name: "Groceries") }

  subject do
    described_class.new(title: title, completed: completed, todo_list: todo_list)
  end

  describe "validations" do
    context "when title is present" do
      let(:title) { "Buy milk" }
      let(:completed) { false }

      it "is valid" do
        expect(subject).to be_valid
      end
    end

    context "when title is blank" do
      let(:title) { "" }
      let(:completed) { false }

      it "is invalid" do
        expect(subject).not_to be_valid
      end

      it "has a validation error on title" do
        subject.validate
        expect(subject.errors[:title]).to include("can't be blank")
      end
    end

    context "when todo_list is missing" do
      let(:title) { "Oranges" }
      let(:completed) { false }

      subject do
        described_class.new(title: title, completed: completed)
      end

      it "is invalid" do
        expect(subject).not_to be_valid
      end

      it "has a validation error on todo_list" do
        subject.validate
        expect(subject.errors[:todo_list]).to include("must exist")
      end
    end
  end

  describe "defaults" do
    describe "defaults completed to false" do
      subject do
        described_class.new(title: "Test item", todo_list: todo_list)
      end

      it "defaults completed to false" do
        subject.save!
        expect(subject.completed).to eq(false)
      end
    end
  end
end
