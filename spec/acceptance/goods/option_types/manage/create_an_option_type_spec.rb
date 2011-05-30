require File.expand_path( '../../../../acceptance_helper', __FILE__ )

feature 'Create an Option Type', %q{
  In order to designate what kinds of options my goods can have
  As an artisan
  I want to create an option type.
} do
  
  background do
    # Given I am on the Manage Option Types page,
    visit '/manage/option_types'
  end
  
  context "with valid information: " do
    background do
      # When I fill in Name with Size and click Create Option Type,
      create_option_type 'Size'
    end
    
    scenario 'I can create an option type with valid information' do
      # Then I should see a notice,
      page.should have_selector '.notice'
    
      # And I should see my new option type.
      page.should have_selector '.option_type', :text => 'Size'
    end
  
    scenario 'I can create an option type with valid information via AJAX', :js => true do
      # Then I should see a notice,
      page.should have_selector '.notice', :text => "Option Type was successfully created."

      # And I should see my new option_type.
      page.should have_selector '.option_type', :text => 'Size'
    end
  end
  
  context "with invalid information: " do
    background do
      # When I fill in Name with nothing and click Create Option Type,
      fill_in 'Name', :with => ''
      click_button 'Create Option Type'
    end
  
    scenario 'I cannot create an option type with invalid information' do
      # Then I should see an alert,
      page.should have_selector '.alert'
    
      # And I should not see any option types.
      page.should have_no_selector '.option_type'
    end
  
    scenario 'I cannot create an option type with invalid information via AJAX', :js => true do
      # Then I should see an alert,
      page.should have_selector '.alert'
    
      # And I should not see any option types.
      page.should have_no_selector '.option_type'
    end
  end
end