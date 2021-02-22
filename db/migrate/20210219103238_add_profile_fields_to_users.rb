class AddProfileFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :text
    add_column :users, :type, :text
  end
end
