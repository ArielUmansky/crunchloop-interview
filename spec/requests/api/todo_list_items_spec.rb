require 'rails_helper'

RSpec.describe "TodoListItems API", type: :request do
  let!(:todo_list) { TodoList.create!(name: "Project Setup") }
  let!(:item) { todo_list.todo_list_items.create!(title: "Install Ruby", completed: false) }
  let(:list_id_param) { todo_list.id }

  describe "GET /api/todolists/:todo_list_id/todos" do

    subject do
      get "/api/todolists/#{list_id_param}/todos"
    end

    it "returns http status ok" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it "returns all items for that list" do
      subject
      expect(JSON.parse(response.body)).to include(include("id" => item.id, "description" => item.title, "completed" => item.completed))
    end

    context "if the list does not exis" do
      let(:list_id_param) { 9999 }

      it "returns http status not found" do
        subject
        expect(response).to have_http_status(:not_found)
      end
      
      it "returns detailed error messages" do
        subject
        json = JSON.parse(response.body)
        expect(json["error"]).to include("TodoList not found")
      end
    end
  end

  describe "GET /api/todolists/:todo_list_id/todos/:id" do
    
    subject do
      get "/api/todolists/#{list_id_param}/todos/#{param_id}"
    end

    context "if the list does not exis" do
      let(:list_id_param) { 9999 }
      let(:param_id) { item.id }

      it "returns http status not found" do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it "returns detailed error messages" do
        subject
        json = JSON.parse(response.body)
        expect(json["error"]).to include("TodoList not found")
      end
      
    end

    context "when the item exists" do
      let(:param_id) { item.id }

      it "returns http status ok" do
        subject
        expect(response).to have_http_status(:ok)
      end

      it "returns the expected structure" do
        subject
        expect(JSON.parse(response.body)).to eq({ "id" => item.id, "description" => item.title, "completed" => item.completed })
      end
    end

    context "when the item does not exist" do
      let(:param_id) { 99999 }

      it "returns 404" do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it "returns detailed error messages" do
        subject
        json = JSON.parse(response.body)
        expect(json["error"]).to include("TodoListItem not found")
      end
    end
  end

  describe "POST /api/todolists/:todo_list_id/todos" do
    subject do
      post "/api/todolists/#{list_id_param}/todos", params: params
    end


    context "if the list does not exis" do
      let(:list_id_param) { 9999 }
      let(:params) { { title: "Configure DB", completed: false } }

      it "returns http status not found" do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it "does not create an item" do
        expect { subject }.not_to change(TodoListItem, :count)
      end

      it "returns detailed error messages" do
        subject
        json = JSON.parse(response.body)
        expect(json["error"]).to include("TodoList not found")
      end
      
    end

    context "with valid params" do
      let(:params) { { title: "Configure DB", completed: false } }

      it "creates a new item" do
        expect { subject }.to change(TodoListItem, :count).by(1)
      end

      it "returns http status created" do
        subject
        expect(response).to have_http_status(:created)
      end

      it "returns the new item structure" do
        subject
        json = JSON.parse(response.body)
        expect(json).to include("id", "description" => "Configure DB", "completed" => false)
      end
    end

    context "with invalid params" do
      let(:params) { { title: "" } }

      it "does not create an item" do
        expect { subject }.not_to change(TodoListItem, :count)
      end

      it "returns http status unprocessable entity" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns detailed error messages" do
        subject
        json = JSON.parse(response.body)
        expect(json["errors"]).to include("Title can't be blank")
      end
    end
  end

  describe "PUT /api/todolists/:todo_list_id/todos/:id" do
    let(:list_item_id_param) { item.id }
    
    subject do
      put "/api/todolists/#{list_id_param}/todos/#{list_item_id_param}", params: params
    end


    context "if the list does not exis" do
      let(:list_id_param) { 9999 }
      let(:params) { { title: "Configure DB", completed: false } }

      it "returns http status not found" do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it "does not create an item" do
        expect { subject }.not_to change(TodoListItem, :count)
      end

      it "returns detailed error messages" do
        subject
        json = JSON.parse(response.body)
        expect(json["error"]).to include("TodoList not found")
      end
      
    end

    context "if the item does not exist" do
      let(:list_item_id_param) { 9999 }
      let(:params) { { title: "Configure DB", completed: false } }

      it "returns http status not found" do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it "does not create an item" do
        expect { subject }.not_to change(TodoListItem, :count)
      end

      it "returns detailed error messages" do
        subject
        json = JSON.parse(response.body)
        expect(json["error"]).to include("TodoListItem not found")
      end
    end

    context "with valid params" do
      let(:params) { { title: "Updated Title", completed: true } }

      it "updates the item" do
        subject
        item.reload
        expect(item.title).to eq("Updated Title")
        expect(item.completed).to eq(true)
      end

      it "returns the updated item" do
        subject
        json = JSON.parse(response.body)
        expect(json).to eq({ "id" => item.id, "description" => "Updated Title", "completed" => true })
      end
    end

    context "with invalid params" do
      let(:params) { { title: "" } }

      it "does not update the item" do
        subject
        item.reload
        expect(item.title).not_to eq("")
      end

      it "returns http status unprocessable entity" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns detailed error messages" do
        subject
        json = JSON.parse(response.body)
        expect(json["errors"]).to include("Title can't be blank")
      end
    end
  end

  describe "DELETE /api/todolists/:todo_list_id/todos/:id" do
    let(:list_item_id_param) { item.id }

    subject do
      delete "/api/todolists/#{list_id_param}/todos/#{list_item_id_param}"
    end

    it "deletes the item" do
      expect { subject }.to change(TodoListItem, :count).by(-1)
    end

    it "returns http status no content" do
      subject
      expect(response).to have_http_status(:no_content)
    end

    context "if the list does not exis" do
      let(:list_id_param) { 9999 }

      it "returns http status not found" do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it "does not create an item" do
        expect { subject }.not_to change(TodoListItem, :count)
      end

      it "returns detailed error messages" do
        subject
        json = JSON.parse(response.body)
        expect(json["error"]).to include("TodoList not found")
      end
      
    end

    context "if the item does not exist" do
      let(:list_item_id_param) { 9999 }

      it "returns http status not found" do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it "does not create an item" do
        expect { subject }.not_to change(TodoListItem, :count)
      end

      it "returns detailed error messages" do
        subject
        json = JSON.parse(response.body)
        expect(json["error"]).to include("TodoListItem not found")
      end
    end

  end
end
