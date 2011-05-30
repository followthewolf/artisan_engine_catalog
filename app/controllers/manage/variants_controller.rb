module Manage
  class VariantsController < Manage::BackController
    respond_to :html, :js
    belongs_to :good
    
    def edit
      @variant = Variant.find( params[ :id ] )
      
      if @variant.is_master?
        redirect_to edit_good_path( @variant.good )
      end
    end
    
    create! do |success, failure|
      success.html { redirect_to edit_good_path @variant.good }
      failure.html { redirect_to edit_good_path( @variant.good ), :alert => 'Variant could not be saved.' }
    
      success.js   { @good = @variant.good }
      failure.js do 
        @good = @variant.good
        flash.now[ :alert ] = 'Variant could not be created.'
        render :create
      end
    end
    
    update! do |success, failure|
      success.html { redirect_to edit_good_path @variant.good }
      failure.html { render :edit }
    end
    
    destroy! do |success, failure|
      success.html { redirect_to edit_good_path @variant.good }
      success.js   { @good = @variant.good }
    end
  end
end