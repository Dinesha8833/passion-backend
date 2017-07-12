class Item < ApplicationRecord
  include AASM
  self.per_page = 10

  validates :title, presence: true
  validates_uniqueness_of :sort_index, scope: :todo_id
  belongs_to :todo

  before_validation :set_sort_index

  scope :sort_by_index, ->() {order(:sort_index)}

  aasm skip_validation_on_save: true do
    state :pending, initial: true
    state :completed

    event :complete do
      transitions from: :pending, to: :completed
    end
  end

  def set_order(index)
    index_exist = todo.items.where(sort_index: index).where.not(id: id).first
    if index_exist
      begin
        transaction do
          items = todo.items.where(sort_index: index.to_i..Float::INFINITY).order('sort_index desc')
          move_index_up(items)
          update_attribute(:sort_index, index)
        end
      rescue Exception => e
        self.errors.add(:base, e.message)
        return false
      end
    else
      update_attribute(:sort_index, index)
    end
  end
  
  private
  # set sort_index if not specified
  def set_sort_index
    self.sort_index = next_sort_index and return unless self.sort_index
  end

  # TODO: improve this logic
  def next_sort_index
    (todo.items.map(&:sort_index).max rescue 0).to_f + 1
  end

  def move_index_up(items)
    items.each do |item|
      item.update_attribute(:sort_index, item.sort_index + 1)
    end
  end
end
