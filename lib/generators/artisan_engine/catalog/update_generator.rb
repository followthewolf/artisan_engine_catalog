require 'rails/generators/active_record'

module ArtisanEngine
  module Generators
    module Catalog
      class UpdateGenerator < ActiveRecord::Generators::Base
  
        argument    :name, :default => 'commerce'
        source_root File.expand_path( '../templates', __FILE__ )
  
        def copy_update_migrations
          migration_template 'migrations/use_has_many_through.rb',
                             'db/migrate/use_has_many_through.rb'
        end
      end
    end
  end
end