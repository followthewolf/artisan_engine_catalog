class Variant < ActiveRecord::Base
  composed_of               :price, :class_name  => 'Money',
                                    :mapping     => [ %w( price_in_cents cents ), %w( currency currency_as_string ) ],
                                    :constructor => Proc.new { |cents, currency| Money.new( cents || 0, currency || Money.default_currency ) },
                                    :converter   => Proc.new { |value| value.respond_to?( :to_money ) ? value.to_money : 0.to_money }
                            
  belongs_to                :good
  has_and_belongs_to_many   :option_values, :before_add => :ensure_no_more_than_one_value_for_each_good_option_type
  
  is_attachable
  
  validates_presence_of     :good, :sku, :price
  validates_numericality_of :price, :greater_than_or_equal_to => 0.01
  validates_uniqueness_of   :sku
  
  validate                  :has_an_option_value_for_each_good_option_type, :unless => :is_master?
  validate                  :no_duplicate_variants_exist

  # ------------------------ Class Methods ------------------------- #

  def self.find_by_good_and_option_values( good_id, option_values_array )
    # Transform array from strings to integers in case the call is coming from a controller.
    option_value_ids = option_values_array.map! { |item| item.to_i }

    for variant in Variant.where( :good_id => good_id )
      return variant if variant.option_value_ids.sort == option_value_ids.sort
    end
    
    nil
  end
  
  def self.option_value_for( variant_id, option_type )
    variant = Variant.find( variant_id )
    variant.option_values.where( :option_type_id => option_type.id ).first if variant
  end

  # ----------------------- Instance Methods ----------------------- #

  def images
    return attached( :images ) if attached( :images ).any?
    good.master_variant.attached( :images )
  end

  # Constructs a string in the format:
  # "Option Type Name: Option Value Name / Option Type Name: Option Value Name"
  def option_values_to_s
    option_values_string = ""
    
    option_values.by_option_type_id.each_with_index do |option_value, index|
      option_values_string << option_value.option_type.name
      option_values_string << ": " + option_value.name
      option_values_string << " / " unless ( index + 1 ) == option_values.size
    end
    
    option_values_string
  end
    

  def option_value_for( option_type )
    option_values.where( :option_type_id => option_type.id ).first
  end

  private

    def has_an_option_value_for_each_good_option_type
      return unless good
      
      required_matches = good.option_types.count
      matches          = 0

      for option_type in good.option_types
        for option_value in option_values
          matches += 1 if option_type.option_values.include?( option_value )
        end
      end
      
      errors.add :base, "A variant must have an option value from each of its good's option types." if required_matches != matches
    end
    
    def ensure_no_more_than_one_value_for_each_good_option_type( option_value )
      for existing_option_value in option_values
        raise "A variant can't have more than one option value for each of its good's option types." if existing_option_value.option_type == option_value.option_type
      end
    end
    
    def no_duplicate_variants_exist
      for variant in Variant.where( :good_id => good_id )
        if variant.option_value_ids.sort == option_value_ids.sort and variant.id != id
          errors.add :base, "A variant already exists with this combination of option values."
        end
      end
    end
end