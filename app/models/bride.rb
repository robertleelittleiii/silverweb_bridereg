class Bride < ActiveRecord::Base
  belongs_to :user
  has_many :gift_registries
  has_many :order_items
  has_many :orders

end
