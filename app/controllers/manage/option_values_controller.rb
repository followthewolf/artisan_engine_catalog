module Manage
  class OptionValuesController < Manage::BackController
    belongs_to :option_type
    respond_to :html, :js
    
    create! do |success, failure|
      success.html { redirect_to manage_option_types_path }
      failure.html do
        flash.now[ :alert ] = 'Option Value could not be saved.'
        render :new
      end
    end
    
    update! do |success, failure|
      success.html { redirect_to manage_option_types_path }
      failure.html do
        flash.now[ :alert ] = 'Option Value could not be saved.'
        render :edit
      end
    end
    
    destroy! do |success, failure|
      success.html { redirect_to manage_option_types_path }
      success.js   { @option_types = OptionType.all }
      failure.js   { @option_types = OptionType.all }
    end
  end
end