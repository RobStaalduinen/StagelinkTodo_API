class AddUserToTodo < ActiveRecord::Migration[5.0]
  def change
  		add_column :todos, :user_id, :integer
  		add_foreign_key :todos, :users

  end
end
