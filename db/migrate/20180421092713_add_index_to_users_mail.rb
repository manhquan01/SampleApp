class AddIndexToUsersMail < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :mail, unique: true
  end
end
