require File.expand_path( '../../acceptance_helper', __FILE__ )

feature 'View Good Variants', %q{
  In order to see variations of a good
  As a patron
  I want to view good variations.
} do
  
  background do
    # Given the artisan has created a good with option types,
    create_good_with_populated_option_types
    
    # And has added two variants to the good,
    create_variant_for 'Cloak of No Particular Color', :sku => 'VAR-01', :price => 1250,
                                                       :values => { :size       => 'Small',
                                                                    :luminosity => 'Dull' }

    create_variant_for 'Cloak of No Particular Color', :sku => 'VAR-02', :price => 2000,
                                                       :values => { :size       => 'Large',
                                                                    :luminosity => 'Blinding' }  
    
    # And I am on the show good page for the good,
    visit '/goods/cloak-of-no-particular-color'
  end
  
  scenario "I see the good's first variant when I visit the show good page" do
    # Then I should see Small and Dull pre-selected,
    page.should have_selector 'option[selected="selected"]', :text => 'Small'
    page.should have_selector 'option[selected="selected"]', :text => 'Dull' 
    
    # And I should see the first variant's price.
    page.should have_content "$1,250.00"
  end
  
  scenario "I see updated variant information when I select an available variant", :js => true do
    # When I select the option values for an available variant,
    select 'Large',    :from => 'Size'
    select 'Blinding', :from => 'Luminosity'
    
    # Then I should see the selected variant's price.
    page.should have_content "$2,000.00"
  end
  
  scenario "I see an unavailability message when I select an unavailable variant", :js => true do
    # When I select the option values for an unavailable variant,
    select 'Medium',    :from => 'Size'
    select 'Brilliant', :from => 'Luminosity'
  
    # Then I should a message that the variant is not available.
    page.should have_content "not available"
  end
end