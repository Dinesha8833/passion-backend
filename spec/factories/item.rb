FactoryGirl.define do
  
  factory :item do
    sequence(:title) { |n| "MyTodo_#{ n }" }
    sequence(:sort_index) { |n| "#{ n }" }
    association :todo
  end

end
