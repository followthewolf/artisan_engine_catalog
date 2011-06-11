module GoodsHelper
  def option_value_for( variant, option_type )
    return nil unless variant and variant.option_values.any?
    Variant.option_value_for( variant.id, option_type ).id
  end
  
  def select_tag_for_option_type( option_type )
    return nil unless option_type.option_values.any?
    
    select_tag "#{ option_type.name }", 
                options_from_collection_for_select( @potential_option_values.select{ |ov| ov.option_type_id == option_type.id }, 
                                                    :id, 
                                                    :name, 
                                                    option_value_for( @variant, option_type ) ),
                :name => 'option_value_ids[]'
  end
  
  def price_for( variant )
    variant ? number_to_currency( variant.price ) : "This variation is not available."
  end
end