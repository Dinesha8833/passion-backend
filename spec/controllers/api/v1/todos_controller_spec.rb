require 'rails_helper'

RSpec.describe Api::V1::TodosController, type: :controller do
   
  before(:each) do
    @todos = []
    2.times { @todos << FactoryGirl.create(:todo) }
  end
  
  describe 'GET #index' do
    it 'should list all todos' do      
      get :index, { format: :json }
      expect(JSON.parse(response.body)).to eq JSON.parse("#{@todos.to_json}")
    end
  end
  
  describe 'POST #create' do
    it 'should create todo' do
      count = Todo.count
      post :create, params: {todo: {name: "todo name" }},format: :json
      json = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(Todo.count).to eq count + 1
    end
    
    it 'should render error message for invalid name' do
      post :create, params: { todo: {name: ""}}, format: :json
      json = JSON.parse(response.body)
      expect(json["message"]).to eq "Name can't be blank"
      expect(json["success"]).to be_falsy
    end
  end
  
  describe 'PUT #update' do
    it 'should update todo' do
      put :update, params: { id: @todos.first.id, todo: {name: "todo name1"}}, format: :json
      json = JSON.parse(response.body)
      expect(json["name"]).to eq "todo name1"
      expect(response.status).to eq 200
    end
    
    it 'should render error message for invalid name' do
      put :update, params: { id: @todos.first.id, todo: {name: ""}}, format: :json
      json = JSON.parse(response.body)
      expect(json["message"]).to eq "Name can't be blank"
      expect(response.status).to eq 400
      expect(json["success"]).to be_falsy
    end
  end
  
  describe 'DELETE #destroy' do
    it 'should delete todo' do
      count = Todo.count
      delete :destroy, params: { id: @todos.first.id}, format: :json
      json = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(Todo.count).to eq count - 1
    end
    
    it 'should render error for invalid todo' do
      delete :destroy, params: { id: "abc"}, format: :json
      json = JSON.parse(response.body)
      expect(json["message"]).to eq "Either todo does not exist or you dont have access to it"
      expect(response.status).to eq 404
    end
  end  
  
end
