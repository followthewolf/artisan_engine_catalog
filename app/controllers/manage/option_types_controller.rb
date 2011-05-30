module Manage
  class OptionTypesController < Manage::BackController
    respond_to :html, :js
    
    create! do |success, failure|
      failure.html { redirect_to manage_option_types_path, :alert => 'Option Type could not be saved.' }
      
      success.js { @option_types = OptionType.all }
      failure.js do 
        @option_types = OptionType.all
        flash.now[ :alert ] = 'Option Type could not be created.'
        render :create
      end
    end
    
    update! do |success, failure|
      failure.html { flash[ :alert ] = 'Option Type could not be saved.'; render :edit }
    end
    
    destroy! do |success, failure|
      success.js { @option_types = OptionType.all }
      failure.js { @option_types = OptionType.all }
    end
  end
end