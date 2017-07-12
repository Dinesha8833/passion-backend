FactoryGirl.define do
  
  factory :todo do
    sequence(:name) { |n| "MyTodo_#{ n }" }    
  end
  
end
