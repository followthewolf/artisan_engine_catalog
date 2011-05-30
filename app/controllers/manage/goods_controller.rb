module Manage
  class GoodsController < Manage::BackController
    respond_to :html, :js
    
    create! do |success, failure|
      success.html { redirect_to edit_good_path @good }
    end
    
    def update
      # Initialize option type IDs array in case user is removing all option types.
      params[ :good ][ :option_type_ids ] ||= []
      
      update! do |success, failure|
        success.html { redirect_to edit_good_path @good }
      end
    end
    
    destroy! do |success, failure|
      success.js { @goods = Good.all }
    end
    
  end
end