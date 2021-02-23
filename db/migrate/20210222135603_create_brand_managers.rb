class CreateBrandManagers < ActiveRecord::Migration[6.0]
  def change
    create_table :brand_manages do |t|
      t.references :user, null: false, foreign_key: true
      t.references :brand, null: false, foreign_key: true
      t.integer :admin_id

      t.timestamps
    end
  end
end
