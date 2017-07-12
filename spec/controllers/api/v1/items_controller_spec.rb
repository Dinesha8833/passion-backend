require 'rails_helper'

RSpec.describe Api::V1::ItemsController, type: :controller do
   
  before(:each) do
    @todo = FactoryGirl.create :todo
    @items = []    
    3.times { @items << @todo.items.create(FactoryGirl.attributes_for(:item)) }
  end
  
  describe 'GET #index' do
    it 'should list all items' do
      get :index, params: { todo_id: @todo.id}, format: :json
      expect(JSON.parse(response.body)).to eq JSON.parse("#{@items.to_json}")
    end        
  end
  
  describe 'POST #create' do
    it 'should create item for todo' do
      count = Item.count
      post :create, params: { item: {title: "item title1", sort_index: rand(10..1000)}, todo_id: @todo.id },format: :json
      json = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(Item.count).to eq count + 1
    end
    
  end
  
  describe 'PUT #update' do
    it 'should update items' do
      put :update, params: { id: @items.first.id, todo_id: @todo.id, item: {title: 'item title1' }}, format: :json
      json = JSON.parse(response.body)
      expect(json["title"]).to eq "item title1"
      expect(response.status).to eq 200
    end
    
    it 'should render error message for invalid title' do
      put :update, params: { id: @items.first.id, todo_id: @todo.id, item: {title: '' }}, format: :json
      json = JSON.parse(response.body)
      expect(json["message"]).to eq "Title can't be blank"
      expect(response.status).to eq 400
      expect(json["success"]).to be_falsy
    end
  end
  
  describe 'PATCH #complete' do
    it 'should set aasm_state as complete' do
      patch :complete, params: { id: @items.first.id, todo_id: @todo.id}, format: :json
      json = JSON.parse(response.body)
      expect(json["aasm_state"]).to eq "completed"
      expect(response.status).to eq 200
    end
    
    it 'should render error for invalid item' do
      patch :complete, params: { id: "abc", todo_id: @todo.id}, format: :json
      json = JSON.parse(response.body)
      expect(json["message"]).to eq "Either item does not exist or you dont have access to it"
      expect(response.status).to eq 404
    end
  end
  
  describe 'PATCH #set_order' do
    it 'should set order' do
      patch :set_order, params: { id: @items.first.id, todo_id: @todo.id, item: {sort_index: @items.last.sort_index.to_i}}, format: :json
      json = JSON.parse(response.body)
      expect(json["sort_index"]).to eq @items.last.sort_index
      expect(response.status).to eq 200
    end
  end
  
  describe 'DELETE #destroy' do
    it 'should delete items of todo' do
      count = Item.count
      delete :destroy, params: { id: @items.first.id, todo_id: @todo.id }, format: :json
      json = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(Item.count).to eq count - 1
    end

    it 'should render error for invalid item' do
      delete :destroy, params: { id: "abc", todo_id: @todo.id}, format: :json
      json = JSON.parse(response.body)
      expect(json["message"]).to eq "Either item does not exist or you dont have access to it"
      expect(response.status).to eq 404
    end
  end

end
