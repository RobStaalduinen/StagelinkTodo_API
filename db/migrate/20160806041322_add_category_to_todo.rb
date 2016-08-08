class AddCategoryToTodo < ActiveRecord::Migration[5.0]
  def change
  	remove_column :todos, :category, :string
  	add_column :todos, :category_id, :integer
  	add_foreign_key :todos, :categories
  end
end
