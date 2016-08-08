class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos do |t|
      t.string :task
      t.string :description
      t.string :category
      t.integer :priority

      t.timestamps
    end
  end
end
