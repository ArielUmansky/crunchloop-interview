require 'rails_helper'

RSpec.describe "TodoLists API", type: :request do
  let!(:todo_list) { TodoList.create!(name: "Initial List") }

  describe "GET /api/todolists" do
    subject { get "/api/todolists" }

    it "returns all todo lists" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it "returns the expected structure" do
      subject
      expect(JSON.parse(response.body)).to include(include("id" => todo_list.id, "name" => todo_list.name))
    end
  end

  describe "GET /api/todolists/:id" do
    subject { get "/api/todolists/#{param_id}" }

    context "when the todo list exists" do
      let(:param_id) { todo_list.id }

      it "returns http status ok" do
        subject
        expect(response).to have_http_status(:ok)
      end

      it "returns the expected structure" do
        subject
        expect(JSON.parse(response.body)).to eq({ "id" => todo_list.id, "name" => todo_list.name })
      end
    end

    context "when the todo list does not exist" do
      let(:param_id) { 999999 }

      it "returns 404 not found" do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /api/todolists" do
    let(:headers) { { "Content-Type" => "application/json" } }

    subject do
      post "/api/todolists", params: params.to_json, headers: headers
    end

    context "with valid params" do
      let(:params) { { name: "New List" } }

      it "creates a todo list" do
        expect { subject }.to change(TodoList, :count).by(1)
      end

      it "returns http status created" do
        subject
        expect(response).to have_http_status(:created)
      end

      it "returns the created todo list with id and name" do
        subject
        json = JSON.parse(response.body)
        expect(json).to include("id", "name")
        expect(json["name"]).to eq(params[:name])
      end
    end

    context "with invalid params" do
      let(:params) { { name: "" } }

      it "does not create a todo list" do
        expect { subject }.not_to change(TodoList, :count)
      end

      it "returns http status unprocessable entity" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns an array of error messages" do
        subject
        json = JSON.parse(response.body)
      
        expect(json["errors"]).to be_an(Array)
        expect(json["errors"]).to include(a_string_matching(/can't be blank/))
      end
    end
  end

  describe "PUT /api/todolists/:id" do
    subject do
       put "/api/todolists/#{param_id}", params: params
    end

    let(:param_id) { todo_list.id }

    context "with valid params" do
      let(:params) { { name: "Updated Name" } }

      it "updates the todo list" do
        subject
        expect(todo_list.reload.name).to eq(params[:name])
      end

      it "returns http status ok" do
        subject
        expect(response).to have_http_status(:ok)
      end

      it "returns the updated todo list" do
        subject
        json = JSON.parse(response.body)
        expect(json).to include("id", "name")
        expect(json["name"]).to eq("Updated Name")
      end
    end

    context "with invalid params" do
      let(:params) { { name: "" } }

      it "does not update the todo list" do
        original_name = todo_list.name
        subject
        expect(todo_list.reload.name).to eq(original_name)
      end

      it "returns http status unprocessable_entity" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns an array of error messages" do
        subject
        json = JSON.parse(response.body)
      
        expect(json["errors"]).to be_an(Array)
        expect(json["errors"]).to include(a_string_matching(/can't be blank/))
      end
    end

    context "when the todo list does not exist" do
      let(:param_id) { 999999 }
      let(:params) { { name: "whatever" } }

      it "returns 404 not found" do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /api/todolists/:id" do
    subject { delete "/api/todolists/#{param_id}" }

    context "when the todo list exists" do
      let(:param_id) { todo_list.id }

      it "deletes the todo list" do
        expect { subject }.to change(TodoList, :count).by(-1)
      end

      it "returns http status no content" do
        subject
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when the todo list does not exist" do
      let(:param_id) { 999999 }

      it "returns 404 not found" do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
