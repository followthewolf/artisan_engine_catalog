require File.expand_path( '../../../../acceptance_helper', __FILE__ )

feature "Add a variant to a good", %q{
  In order to add variations of my good to my catalog
  As an artisan
  I want to add a variant to my good.
} do
  
  background do
    # Given I have created a good with two populated option types,
    create_good_with_populated_option_types

    # And I am on the Edit Good page for the good,
    visit "/goods/cloak-of-no-particular-color/edit"
  end
  
  context "with valid information: " do
    background do
      # When I fill in valid information for my variant and click Add Variant,
      create_variant_for 'Cloak of No Particular Color', :sku => 'VAR-01'
    end
    
    scenario "I can add a variant with valid information to a good" do
      # Then I should see a notice,
      page.should have_selector '.notice', :text => 'Variant was successfully created.'
      
      # Then I should see my variant
      page.should have_selector '.variant', :text => 'VAR-01'
    end
  
    scenario "I can add a variant with valid information to a good via AJAX", :js => true do
      # Then I should see a notice,
      page.should have_selector '.notice', :text => 'Variant was successfully created.'
    
      # And I should see my variant.
      page.should have_selector '.variant', :text => 'VAR-01'
    end
  end
  
  context "with invalid information: " do
    background do
      # When I fill in invalid information for my variant and click Add Variant,
      within '#add_variant' do
        fill_in 'SKU',    :with => ''
        fill_in 'Price',  :with => '-0'
        select  'Small',  :from => 'Size'
        select  'Dull',   :from => 'Luminosity'

        click_button 'Add Variant'
      end
    end
  
    scenario "I cannot add a variant with invalid information to a good" do
      # Then I should see an alert,
      page.should have_selector '.alert', :text => 'Variant could not be saved.'
    
      # And I should see no variants.
      page.should have_no_selector '.variant'
    end
  
    scenario "I cannot add a variant with invalid information to a good via AJAX", :js => true do
      # Then I should see an alert,
      page.should have_selector '.alert', :text => 'Variant could not be created.'
    
      # And I should see no variants.
      page.should have_no_selector '.variant'
    end
  end
end