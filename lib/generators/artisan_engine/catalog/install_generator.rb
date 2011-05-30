require 'rails/generators/active_record'

module ArtisanEngine
  module Generators
    module Catalog
      class InstallGenerator < ActiveRecord::Generators::Base

        argument    :name, :default => 'catalog'
        source_root File.expand_path( '../templates', __FILE__ )

        def install_core
          Rails::Generators.invoke 'artisan_engine:core:install'
          sleep 1 # to prevent duplicate timestamps.
        end
        
        def install_attachments
          Rails::Generators.invoke 'artisan_engine:attachments:install'
          sleep 1 # to prevent duplicate timestamps.
        end

        def copy_installation_migration
          migration_template 'migrations/install_artisan_engine_catalog.rb', 
                             'db/migrate/install_artisan_engine_catalog.rb'
          
          sleep 1 # to prevent duplicate timestamps.
        end
        
      end
    end
  end
end