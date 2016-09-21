class CreateBrideUserRole < ActiveRecord::Migration
  def self.up

		#Bride role name should be "Bride" for convenience
    bride_role = Role.new
		bride_role.name = "Bride"
		bride_role.save

    
    customer_role = Role.find_by_name("Customer")

    #Create all of the rights for all existing controllers for the admin
    #assign them to Admin role.

    right = Right.create name: "*Access to bride info", controller: "site", action: "show_my_gifts"
    bride_role.rights << right
    
    right = Right.create name: "*Access to bride admin actions", controller: "admin", action: "login,logout,index"
    bride_role.rights << right
    customer_role.rights << right
   
    right = Right.create name: "*Access to bride password actions", controller: "users", action: "change_password,update_password"
    bride_role.rights << right
    customer_role.rights << right

    right = Right.find_by_name("*Access to all login actions")
    bride_role.rights << right
   
    right = Right.find_by_name("*Access to all user attributes actions")
    bride_role.rights << right

  end

  def self.down
   
    #Get Admin Role
		bride_role = Role.find_by_name("Bride")

    #Destroy Admin Role
    bride_role.destroy rescue puts("Bride Role Not found.")
    
    #Destroy all rights
    right = Right.find_by_name("*Access to bride info")
    right.destroy rescue puts("Right '*Access to bride info' Not found.")
  
    right = Right.find_by_name("*Access to bride admin actions")
    right.destroy rescue puts("Right '*Access to bride admin actions' Not found.")
  
    right = Right.find_by_name("*Access to bride password actions")
    right.destroy rescue puts("Right '*Access to bride password actions' Not found.")
  
  end
end
