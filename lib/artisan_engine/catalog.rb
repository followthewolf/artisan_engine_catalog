require 'artisan_engine/core'
require 'artisan_engine/listability'
require 'artisan_engine/attachments'
require 'money'
require 'nested_has_many_through'
require 'artisan_engine/catalog'

module ArtisanEngine
  module Catalog

    # ------------------ Autoload Necessary Modules ------------------ #
    
    autoload :TestHelpers, 'artisan_engine/catalog/test_helpers' if Rails.env.test?
    
    # ------------------------- Vroom vroom! ------------------------- #
    
    class Engine < Rails::Engine
      config.before_configuration do
        ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion :artisan_engine       => [ "artisan_engine/catalog/back" ],
                                                                          :artisan_engine_front => [ "artisan_engine/catalog/front" ]
      end
      
      config.to_prepare do
        ActiveRecord::Base.observers << GoodObserver
      end
        
    end

  end
end