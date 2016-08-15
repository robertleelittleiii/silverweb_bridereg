module BridesHelper


def bride_info(bride)
    returnval = "<div id=\"attr-bride\" class=\"hidden-item\">"
    returnval << "<div id=\"bride-id\">"+(bride.id.to_s rescue "-1")+"</div>"
    returnval << "<div id=\"user-id\">"+(bride.user.id.to_s rescue "-1")+"</div>"
    
    returnval=returnval + "</div>"
    return returnval.html_safe
 
  end
  
  def bride_edit_div(bride)
    returnval=""
    if session[:user_id] then
      user=User.find(session[:user_id])
      if user.roles.detect{|role|((role.name=="Admin") | (role.name=="Site Owner"))} then
        returnval="<div id=\"edit-bride\" class=\"edit-bride\">"
        returnval << "<div id='bride-id' class='hidden-item'>#{bride.id}</div>"
        returnval=returnval+image_tag("interface/edit.png",:border=>"0", :class=>"imagebutton", :title => "Edit this Bride")
        returnval=returnval + "</div>"

      end
    end
    return returnval.html_safe
  end
  

end

  


