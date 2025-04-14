class ChangeRoleToIntegerInUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :role, :string  # or :text, depending on what it was before
    add_column :users, :role, :integer, default: 0, null: false
  end
end
