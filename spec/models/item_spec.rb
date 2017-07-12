require 'rails_helper'

RSpec.describe Item, type: :model do
  
  describe "Associations" do
    it { should belong_to(:todo) }  
  end
  
  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_uniqueness_of(:sort_index).scoped_to(:todo_id) }
  end
  
  
  context 'instance methods' do
    before(:each) do      
      @todo = FactoryGirl.create :todo
      @items = []    
      3.times { @items << @todo.items.create(FactoryGirl.attributes_for(:item)) }      
    end

    describe '#set_order' do
      it 'should return new order' do
        item1 = @items.first
        item3 = @items.last
        expect(item3.set_order(item1.sort_index)).to be_truthy
        expect(@todo.items.last.sort_index).to eq item1.sort_index
        expect(@todo.items.first.sort_index).to eq item1.sort_index + 1
      end
    end
  end
  
end
  
