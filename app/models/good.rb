class Good < ActiveRecord::Base
  attr_accessor             :sku, :price
  
  has_one                   :master_variant,
                              :class_name => 'Variant',
                              :conditions => { :is_master => true },
                              :dependent  => :destroy
  
  has_many                  :variants,
                              :conditions => { :is_master => false },
                              :dependent  => :destroy
  
  has_many                  :good_option_types
  has_many                  :option_types, :through => :good_option_types,
                              :before_add    => :ensure_no_variants,
                              :before_remove => :ensure_no_variants  
  
  has_many                  :potential_option_values, 
                              :through  => :variants, 
                              :source   => :option_values
  
  
  has_friendly_id           :name, 
                              :use_slug => true

  validates_presence_of     :sku, :name, :description, :price
  
  validates_numericality_of :price, 
                              :greater_than => 0
  
  validate                  :no_variants_with_duplicate_sku
  
  # Convert price to Money.
  def price=( value )
    value.respond_to?( :to_money ) ? @price = value.to_money : @price = 0.to_money
  end
  
  # Ensure that the good destroys all its variants before destroying itself,
  # otherwise it will trigger the ensure_no_variants callback on option_types.
  def destroy
    variants.destroy_all
    super
  end
  
  def image
    master_variant.images.first
  end
  
  private
      
    def ensure_no_variants( option_type )
      raise "Can't change option types on a good with variants." if variants.any?
    end
    
    def no_variants_with_duplicate_sku
      variant_with_duplicate_sku = nil
      
      if master_variant
        variant_with_duplicate_sku = Variant.where( "sku = '#{ sku }' AND id != #{ master_variant.id }" ).first
      else
        variant_with_duplicate_sku = Variant.where( :sku => sku ).first
      end
      
      errors.add :sku, "must be unique." if variant_with_duplicate_sku
    end

end