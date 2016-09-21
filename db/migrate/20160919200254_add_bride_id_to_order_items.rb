class AddBrideIdToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :bride_id, :integer
  end
end
