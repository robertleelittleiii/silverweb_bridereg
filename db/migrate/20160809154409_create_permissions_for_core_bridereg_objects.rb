class CreatePermissionsForCoreBrideregObjects < ActiveRecord::Migration
  def self.up
    #assign them to Admin role.
    role_admin =  Role.find_by_name('Admin')
    role_cust =  Role.find_by_name('Customer')
    role_siteowner =  Role.find_by_name('Site Owner')

    right = Right.create name: "*Access to all Bride actions", controller: "brides", action: "*"
    role_admin.rights << right
    role_siteowner.rights << right
    
    right = Right.create name: "*Access to all Gift Registries actions", controller: "gift_registries", action: "*"
    role_admin.rights << right
    role_siteowner.rights << right
    
    
    role_siteowner.save
    role_cust.save
    role_admin.save 
  end

  def self.down
    #Destroy all rights    
    right = Right.find_by_name( "*Access to all Bride actions")
    right.destroy  rescue puts("Bride permissions not found.")

    right = Right.find_by_name( "*Access to all Gift Registries actions")
    right.destroy  rescue puts("Gift Registries permissions not found.")

  end
end
