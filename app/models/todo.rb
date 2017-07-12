class Todo < ApplicationRecord
  self.per_page = 5
  validates :name, presence: true

  has_many :items, dependent: :destroy
end
