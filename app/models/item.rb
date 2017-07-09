class Item < ApplicationRecord

  validates :title, presence: true
  validates_uniqueness_of :sort_index, scope: :todo_id
  belongs_to :todo

  before_validation :set_sort_index

  scope :sort_by_index, ->() {order(:sort_index)}

  private
  # set sort_index if not specified
  def set_sort_index
    self.sort_index = next_sort_index and return unless self.sort_index
  end

  # TODO: improve this logic
  def next_sort_index
    (todo.items.map(&:sort_index).max rescue 0) + 1
  end
end
