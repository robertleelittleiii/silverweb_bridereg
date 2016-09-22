Rails.application.routes.draw do
  
  resources :gift_registries do
    collection do
      get "create_empty_record"
      post "gift_registries_table"
      delete "delete" 
      
    end
  end
  
  resources :brides do
    collection do

      get "create_empty_record"
      post "bride_table"
      delete "delete" 
      post "update_gift_list"
      post "render_gift_section"
      post "update_gift_order"
    end
  end
  
  resources :order_management do
    collection do
      get 'order_page'
      post 'add_to_order'
      get 'complete_order'
      put 'update_cart_item'
      post 'complete_order'
      get 'complete_order'
      post 'enter_order'
      get 'enter_order'
      get 'get_product_sub_totals'
    end
  end
  
    match "/site/show_my_gifts" => "site#show_my_gifts", via: :get
    match "/site/show_gifts" => "site#show_gifts", via: :get
    match "/site/update_cart_item" => "site#update_cart_item", via: :put
    match "/site/update_session" => "site#update_session", via: :put
    match "/site/find_bride" => "site#find_bride", via: :get
    match "/site/bride_active" => "site#bride_active", via: :get

  
end
