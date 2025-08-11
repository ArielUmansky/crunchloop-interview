require 'rails_helper'

describe Api::TodoListsController, type: :controller do
  render_views

  describe "GET index" do
    let!(:todo_list) { TodoList.create!(name: "Sample list") }

    subject do
      get :index, format: :json
    end

    it "returns HTTP status ok" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it "returns the correct JSON structure" do
      subject
      json = JSON.parse(response.body)
      expect(json).to include(include("id" => todo_list.id, "name" => todo_list.name))
    end
  end

  describe "GET show" do
    subject do
      get :show, params: { id: param_id }, format: :json
    end

    context "when the todo list exists" do
      let!(:todo_list) { TodoList.create!(name: "Sample list") }
      let(:param_id) { todo_list.id }

      it "returns HTTP status ok" do
        subject
        expect(response).to have_http_status(:ok)
      end

      it "returns the todo list" do
        subject
        json = JSON.parse(response.body)
        expect(json).to eq({ "id" => todo_list.id, "name" => todo_list.name, "progress" => 0 })
      end
    end

    context "when the todo list does not exist" do
      let(:param_id) { -1 }

      it "returns HTTP status not found" do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it "returns an error message" do
        subject
        json = JSON.parse(response.body)
        expect(json).to include("error" => "Not Found")
      end
    end
  end

  describe "POST create" do
    subject do
      post :create, params: params, format: :json
    end

    context "with valid params" do
      let(:params) { { name: "New List" } }

      it "creates a new todo list" do
        expect {
          subject
        }.to change(TodoList, :count).by(1)
      end

      it "returns HTTP status created" do
        subject
        expect(response).to have_http_status(:created)
      end

      it "returns the created record" do
        subject
        json = JSON.parse(response.body)
        expect(json).to include("id", "name")
        expect(json["name"]).to eq("New List")
      end
    end

    context "with invalid params" do
      let(:params) { { name: "" } }

      it "does not create a todo list" do
        expect {
          subject
        }.not_to change(TodoList, :count)
      end

      it "returns HTTP status unprocessable entity" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error messages" do
        subject
        json = JSON.parse(response.body)
        expect(json).to include("errors" => include("Name can't be blank"))
      end
    end
  end

  describe "PUT update" do
    let!(:todo_list) { TodoList.create!(name: "Original Name") }

    subject do
      put :update, params: { id: todo_list.id, name: new_name }, format: :json
    end

    context "with valid params" do
      let(:new_name) { "Updated Name" }

      it "updates the todo list" do
        subject
        expect(todo_list.reload.name).to eq("Updated Name")
      end

      it "returns HTTP status ok" do
        subject
        expect(response).to have_http_status(:ok)
      end

      it "returns the updated todo list" do
        subject
        json = JSON.parse(response.body)
        expect(json).to include("id" => todo_list.id, "name" => "Updated Name")
      end
    end

    context "with invalid params" do
      let(:new_name) { "" }

      it "does not update the todo list" do
        subject
        expect(todo_list.reload.name).to eq("Original Name")
      end

      it "returns HTTP status unprocessable entity" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error messages" do
        subject
        json = JSON.parse(response.body)
        expect(json).to include("errors" => include("Name can't be blank"))
      end
    end
  end

  describe "DELETE destroy" do
    let!(:todo_list) { TodoList.create!(name: "To be deleted") }

    subject do
      delete :destroy, params: { id: todo_list.id }, format: :json
    end

    it "deletes the record" do
      expect {
        subject
      }.to change(TodoList, :count).by(-1)
    end

    it "returns HTTP status no content" do
      subject
      expect(response).to have_http_status(:no_content)
    end
  end
end
