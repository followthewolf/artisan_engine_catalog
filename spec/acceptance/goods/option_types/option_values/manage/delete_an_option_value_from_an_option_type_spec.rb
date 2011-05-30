require File.expand_path( '../../../../../acceptance_helper', __FILE__ )

feature 'Delete an Option Value from an Option Type', %q{
  In order to manage my option types' option values
  As an artisan
  I want to delete an option value from a option type.
} do
  
  background do 
    # Given I have created a option type named 'Size'
    create_option_type 'Size'
    
    # And I have created an option value named 'Small'
    create_option_value 'Size', 'Small'
    
    # And I am on the Manage Option Types page,
    visit '/manage/option_types'
    
    # When I click the option value's Delete button
    within '.option_type .option_value' do
      click_button 'Delete'
    end
  end
  
  scenario "I can delete an option value from an option type" do
    # Then I should see a notice
    page.should have_selector '.notice', :text => 'Option Value was successfully destroyed.'
    
    # And I should see no option values in my option type.
    within '.option_type' do
      page.should have_no_selector '.option_value'
    end
  end
  
  scenario "I can delete a option value from a option type via AJAX", :js => true do
    # And I confirm in the modal window
    accept_confirmation
    
    # Then I should see a notice
    page.should have_selector '.notice', :text => 'Option Value was successfully destroyed.'
    
    # And I should see no option values in my option type.
    within '.option_type' do
      page.should have_no_selector '.option_value'
    end
  end
end