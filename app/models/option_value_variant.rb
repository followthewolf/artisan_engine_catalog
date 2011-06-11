class OptionValueVariant < ActiveRecord::Base
  set_table_name "option_values_variants"
  
  belongs_to :option_value
  belongs_to :variant
end