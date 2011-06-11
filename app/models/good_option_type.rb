class GoodOptionType < ActiveRecord::Base
  set_table_name "goods_option_types"
  
  belongs_to :good
  belongs_to :option_type
end