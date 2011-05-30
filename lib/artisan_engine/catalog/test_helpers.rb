module ArtisanEngine
  module Catalog
    module TestHelpers

      def random_price
        Forgery::Monetary.money :min => 1, :max => 1000
      end
      
      # ----------------------------- Goods ---------------------------- #
      
      def random_good_name
        Forgery::Address.country + " " + Forgery::Name.company_name
      end
      
      Factory.sequence :good_sku do |number_in_sequence|
        "GOOD-#{ number_in_sequence }"
      end
      
      Factory.define :good do |g|
        g.sku           { Factory.next :good_sku }
        g.name          { random_good_name }
        g.description   { Forgery::LoremIpsum.paragraphs( 3 ) }
        g.price         { random_price }
      end
      
      Factory.define :good_with_size_and_color, :parent => :good do |scg|
        scg.after_create do |scg|
          scg.option_types << Factory( :size_option_type )
          scg.option_types << Factory( :color_option_type )
        end
      end
      
      # ------------------------- Option Types ------------------------- #

      Factory.define :option_type do |ot|
        ot.name         { Forgery::Name.company_name.pluralize }
      end
      
      Factory.define :size_option_type, :parent => :option_type do |sot|
        sot.name      'Size'
        
        sot.after_create do |sot|
          sot.option_values.create! :name => 'Small'
          sot.option_values.create! :name => 'Medium'
          sot.option_values.create! :name => 'Large'
        end
      end
      
      Factory.define :color_option_type, :parent => :option_type do |cot|
        cot.name      'Color'
        
        cot.after_create do |cot|
          cot.option_values.create! :name => 'Red'
          cot.option_values.create! :name => 'Green'
          cot.option_values.create! :name => 'Blue'
        end
      end
      
      def size; OptionType.find_by_name( 'Size' ); end;
      def color; OptionType.find_by_name( 'Color' ); end;
      
      # ------------------------ Option Values ------------------------- #
      
      Factory.define :option_value do |ov|
        ov.name         { Forgery::Name.company_name.pluralize }
        ov.association  :option_type
      end
      
      def small; OptionValue.find_by_name( 'Small' ); end;
      def medium; OptionValue.find_by_name( 'Medium' ); end;
      def large; OptionValue.find_by_name( 'Large' ); end;
      def red; OptionValue.find_by_name( 'Red' ); end;
      def green; OptionValue.find_by_name( 'Green' ); end;
      def blue; OptionValue.find_by_name( 'Blue' ); end;  
      
      # --------------------------- Variants --------------------------- #
      
      Factory.sequence :variant_sku do |number_in_sequence|
        "VAR-#{ number_in_sequence }"
      end
      
      Factory.define :variant do |v|
        v.sku           { Factory.next :variant_sku }
        v.price         { random_price }
      end
      
      Factory.define :small_blue_variant, :parent => :variant do |v|
        v.association   :good, :factory => :good_with_size_and_color
        
        v.after_build do |v|
          v.option_values << small
          v.option_values << blue
        end
      end
       
      module Integration
        
        # ----------------------------- Goods ---------------------------- #
        
        def create_good( options = {} )
          visit '/goods/new'
          
          fill_in 'SKU',          :with => options[ :sku ]         || Factory.next( :good_sku )
          fill_in 'Name',         :with => options[ :name ]        || random_good_name
          fill_in 'Description',  :with => options[ :description ] || Forgery::LoremIpsum.paragraphs( 3 )
          fill_in 'Price',        :with => options[ :price ]       || random_price

          click_button 'Create Good'
        end
        
        def create_good_with_populated_option_types( options = {} )
          good_name      = options[ :name ]           || 'Cloak of No Particular Color'
          first_ot_name  = options[ :first_ot_name ]  || 'Size'
          second_ot_name = options[ :second_ot_name ] || 'Luminosity'
          
          # Create a good.
          create_good :name => good_name
          
          # Create option types.
          create_option_type( first_ot_name ) 
          create_option_type( second_ot_name )
          
          # Add option types to the good.
          add_option_type first_ot_name,  :to => good_name
          add_option_type second_ot_name, :to => good_name
          
          # Add option values to the first option type.
          first_ot_option_values = options[ :first_ot_option_values ] || %w( Small Medium Large )
          
          for value in first_ot_option_values
            create_option_value first_ot_name, value
          end
          
          # Add option values to the second option type.
          second_ot_option_values = options[ :second_ot_option_values ] || %w( Dull Brilliant Blinding )
          
          for value in second_ot_option_values
            create_option_value second_ot_name, value
          end
        end
        
        # ------------------------- Option Types ------------------------- #
        
        def create_option_type( name )
          visit '/manage/option_types'
          
          fill_in 'Name', :with => name
          click_button 'Create Option Type'
        end
        
        def add_option_type( name, options = {} )
          url_for_good = options[ :to ].downcase.gsub( ' ', '-' )
          
          visit "/goods/#{ url_for_good }/edit"
          
          check name
          click_button 'Update Good'
        end
        
        # ------------------------ Option Values ------------------------- #
        
        def create_option_value( type, name )
          option_type = OptionType.find_by_name( type )
          
          visit "/option_types/#{ option_type.id }/option_values/new"
          fill_in 'Name', :with => name
          click_button 'Create Option Value'
        end
        
        # --------------------------- Variants --------------------------- #
        
        def create_variant_for( good_name, options = {} )
          options[ :values ] ||= { :size       => 'Small', 
                                   :luminosity => 'Dull' }
          
          good = Good.find_by_name( good_name )
          visit "/goods/#{ good.id }/edit"
          
          within '#add_variant' do
            fill_in 'SKU',   :with => options[ :sku ]   || Factory.next( :variant_sku )
            fill_in 'Price', :with => options[ :price ] || random_price
            
            options[ :values ].each do |key, value|
              select value, :from => key.to_s.titleize
            end
            
            click_button 'Add Variant'
          end
        end
      end
      
    end
  end
end