class CreateTodos < ActiveRecord::Migration[5.1]
  def change
    create_table :todos do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end

    add_index :todos, :user_id
  end
end
