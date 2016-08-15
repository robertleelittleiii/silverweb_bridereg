class Bride < ActiveRecord::Base
  belongs_to :user
  has_many :gift_registries
  
end
