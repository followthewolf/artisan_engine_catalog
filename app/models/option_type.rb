class OptionType < ActiveRecord::Base
  has_many                :option_values, :dependent => :destroy
  has_many                :good_option_types
  has_many                :goods, :through => :good_option_types
  
  has_listability
  
  validates_presence_of   :name
  
  before_destroy          :ensure_no_assigned_goods
  
  private
  
    def ensure_no_assigned_goods
      errors.add( :base, "Can't destroy an option type which is assigned to any goods." ) and return false if goods.any?
    end
end