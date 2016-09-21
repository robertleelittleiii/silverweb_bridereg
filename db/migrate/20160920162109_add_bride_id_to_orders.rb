class AddBrideIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :bride_id, :integer
  end
end
