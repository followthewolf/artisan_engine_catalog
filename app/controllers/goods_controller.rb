class GoodsController < FrontController
  def show
    @good                    = Good.find( params[ :id ] )
    @title                   = @good.name
    @potential_option_values = @good.potential_option_values.in_position.uniq
    
    if params[ :option_values ]
      option_values_array = params[ :option_values ].split( 'x' ).sort
      @variant = Variant.find_by_good_and_option_values( @good.id, option_values_array )
    
    elsif @good.variants.any?
      @variant = @good.variants.first
    
    else
      @variant = @good.master_variant
    
    end
  end
end