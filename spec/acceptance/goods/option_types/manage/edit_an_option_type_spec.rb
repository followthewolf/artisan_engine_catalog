require File.expand_path( '../../../../acceptance_helper', __FILE__ )

feature 'Edit an Option Type', %q{
  In order to manage my options
  As an artisan
  I want to edit a option type.
} do

  background do
    # Given I am on the Manage Option Types page,
    visit '/manage/option_types'
    
    # And I have created a option type named 'Size.'
    create_option_type 'Size'
  end
  
  scenario "Edit a option type with valid attributes" do
    # When I click the option type's Edit link,
    within '.option_type' do
      click_link 'Edit'
    end
    
    # And I fill in a new name and click Update Option Type,
    fill_in 'Name', :with => 'Sizeorama'
    click_button 'Update Option Type'

    # Then I should see a notice
    page.should have_selector '.notice', :text => 'Option Type was successfully updated.'
    
    # And I should see my new option type
    page.should have_selector '.option_type', :text => 'Sizeorama'
  end
  
  scenario "Edit a option type with invalid attributes" do
    # When I click the option type's Edit link,
    within '.option_type' do
      click_link 'Edit'
    end
    
    # And I fill in an invalid new name and click Update Option Type,
    fill_in 'Name', :with => ''
    click_button 'Update Option Type'

    # Then I should see an alert
    page.should have_selector '.alert', :text => 'Option Type could not be saved.'
  end
end
