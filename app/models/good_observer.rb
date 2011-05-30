class GoodObserver < ActiveRecord::Observer

  # -------------------------- Callbacks --------------------------- #
  
  def after_create( good )
    create_master_variant( good )
  end
  
  def after_find( good )
    initialize_attributes_from_master_variant( good )
  end
  
  def after_update( good )          
    update_master_variant( good )
  end
  
  # ------------------- Master Variant Management ------------------ #
  
  # Creates a master variant with the good's SKU and price.
  def create_master_variant( good )
    good.create_master_variant :good      => good, 
                               :sku       => good.sku, 
                               :price     => good.price,
                               :is_master => true
  end
  
  # Initializes SKU and Price from the master variant.
  def initialize_attributes_from_master_variant( good )
    good.sku   = good.master_variant.sku
    good.price = good.master_variant.price
  end
  
  # Updates the master variant with the good's SKU and price.
  def update_master_variant( good )
    good.master_variant.update_attributes :price => good.price, 
                                          :sku   => good.sku
  end
end