class GiftRegistry < ActiveRecord::Base
  belongs_to :product
  belongs_to :bride
  
  
   def self.reorder(id,position)
    puts(id, position)
    ActiveRecord::Base.connection.execute ("UPDATE `gift_registries` SET `position` = '"+position.to_s+"' WHERE `gift_registries`.`id` ="+id.to_s+" LIMIT 1 ;")
  end
  
   def quantity_left
     return quantity_requested - quantity_reserved rescue 0
   end
   
end
