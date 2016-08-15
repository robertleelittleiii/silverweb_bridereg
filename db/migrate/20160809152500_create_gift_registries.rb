class CreateGiftRegistries < ActiveRecord::Migration
  def change
    create_table :gift_registries do |t|
      t.integer :bride_id
      t.integer :product_id
      t.integer :quantity_requested
      t.integer :quantity_reserved
      t.integer :position
      t.timestamps null: false
    end
  end
end
