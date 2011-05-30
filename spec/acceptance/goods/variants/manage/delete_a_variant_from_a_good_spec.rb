require File.expand_path( '../../../../acceptance_helper', __FILE__ )

feature "Delete a variant from a good", %q{
  In order to remove variations of my good from my catalog
  As an artisan
  I want to delete a variant from a good.
} do
  
  background do
    # Given I have created a good with two populated option types,
    create_good_with_populated_option_types

    # And I have created a variant for the good
    create_variant_for 'Cloak of No Particular Color'

    # And I am on the Edit Good page,
    visit "/goods/cloak-of-no-particular-color/edit"
    
    # When I click the variant's Delete button,
    within '.variant' do
      click_button 'Delete'
    end
  end
  
  scenario "I can delete a variant from a good" do
    # Then I should see a notice
    page.should have_selector '.notice', :text => 'Variant was successfully destroyed.'
    
    # And I should see no variants
    page.should have_no_selector '.variant'
  end
  
  scenario "I can delete a variant from a good via AJAX", :js => true do
    # When I confirm in the modal window
    accept_confirmation
    
    # Then I should see a notice
    page.should have_selector '.notice', :text => 'Variant was successfully destroyed.'
    
    # And I should see no variants
    page.should have_no_selector '.variant'
  end
end