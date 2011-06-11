class OptionValue < ActiveRecord::Base
  belongs_to              :option_type
  has_many                :option_value_variants
  has_many                :variants, :through => :option_value_variants
  
  has_listability         :within => :option_type
  
  scope                   :by_option_type_id, lambda {
                            joins( :option_type ).
                            order( "option_types.id ASC" )
                          }
  
  validates_presence_of   :name, :option_type

  before_destroy          :ensure_no_assigned_variants
  
  private
  
    def ensure_no_assigned_variants
      errors.add( :base, "Can't destroy an option value which is assigned to any variants." ) and return false if variants.any?
    end
end