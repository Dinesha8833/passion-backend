require 'rails_helper'

RSpec.describe Todo, type: :model do

  describe "Associations" do
    it { should have_many(:items) }    
  end
  
  describe "validations" do
    it { should validate_presence_of :name }
  end

end
