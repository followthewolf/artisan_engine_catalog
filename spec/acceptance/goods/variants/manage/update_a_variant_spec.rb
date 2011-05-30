require File.expand_path( '../../../../acceptance_helper', __FILE__ )

feature "Update a variant", %q{
  In order to manage my variants
  As an artisan
  I want to update a variant.
} do
  
  background do
    # Given I have created a good with two populated option types,
    create_good_with_populated_option_types

    # And I have created a variant for the good
    create_variant_for 'Cloak of No Particular Color'

    # And I am on the Edit Good page,
    visit "/goods/cloak-of-no-particular-color/edit"
    
    # And I have clicked the variant's Edit link,
    within '.variant' do
      click_link 'Edit'
    end
  end
  
  scenario "I can update a variant with valid attributes" do
    # When I fill in valid information for the variant and click the Update Variant button,
    fill_in 'SKU', :with => 'UPDATED-SKU'
    click_button 'Update Variant'
    
    # Then I should see a notice,
    page.should have_selector '.notice'
    
    # And I should see my updated variant,
    page.should have_selector '.variant', :text => 'UPDATED-SKU'
  end
  
  scenario "I cannot update a variant with invalid attributes" do
    # When I fill in valid information for the variant and click the Update Variant button,
    fill_in 'SKU', :with => ''
    click_button 'Update Variant'
    
    # Then I should see an alert.
    page.should have_selector '.alert'
  end
end