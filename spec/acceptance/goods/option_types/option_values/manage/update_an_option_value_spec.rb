require File.expand_path( '../../../../../acceptance_helper', __FILE__ )

feature 'Update an Option Value', %q{
  In order to manage my options
  As an artisan
  I want to update a option value.
} do

  background do
    # Given I have created a option type named 'Size'
    create_option_type 'Size'
    
    # And I have created an option value named 'Small'
    create_option_value 'Size', 'Small'
    
    # And I am on the Manage Option Types page,
    visit '/manage/option_types'
    
    # When I click the option value's Edit link
    within '.option_type .option_value' do
      click_link 'Edit'
    end
  end
  
  scenario "I can update a option value with valid information" do
    # When I fill in a new name and click Update Option Value,
    fill_in 'Name', :with => 'Miniscule'
    click_button 'Update Option Value'

    # Then I should see a notice
    page.should have_selector '.notice', :text => 'Option Value was successfully updated.'
    
    # And I should see my new option value
    within '.option_type' do
      page.should have_selector '.option_value', :text => 'Miniscule'
    end
  end
  
  scenario "I cannot update a option value with invalid information" do    
    # When I fill in an invalid new name and click Update Option Value,
    fill_in 'Name', :with => ''
    click_button 'Update Option Value'

    # Then I should see an alert.
    page.should have_selector '.alert', :text => 'Option Value could not be saved.'
  end
end
