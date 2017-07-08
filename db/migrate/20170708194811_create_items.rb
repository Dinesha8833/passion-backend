class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :title
      t.integer :todo_id
      t.integer :sort_index

      t.timestamps
    end
  end
end
