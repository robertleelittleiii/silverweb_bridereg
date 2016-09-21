class GiftRegistry < ActiveRecord::Base
  belongs_to :product
  belongs_to :bride
  
   def self.reorder(id,position)
    puts(id, position)
    ActiveRecord::Base.connection.execute ("UPDATE `gift_registries` SET `position` = '"+position.to_s+"' WHERE `gift_registries`.`id` ="+id.to_s+" LIMIT 1 ;")
  end
  
   def true_quantity_reserved
     self.bride.order_items.where(:product_id => product_id).sum(:quantity)
   end
  
   def quantity_left
     return quantity_requested - true_quantity_reserved rescue 0
   end
   
end
