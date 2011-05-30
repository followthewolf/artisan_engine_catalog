require File.expand_path( '../../../../acceptance_helper', __FILE__ )

feature 'Delete an Option Type', %q{
  In order to manage my option types
  As an artisan
  I want to delete an option type.
} do

  background do
    # Given I am on the Manage Option Types page,
    visit '/manage/option_types'
    
    # And I have created a option type named 'Size'
    create_option_type 'Size'
  end
  
  scenario 'I can delete an option type' do
    # When I click the option type's remove link,
    within '.option_type' do
      click_button 'Delete'
    end
    
    # Then I should see a notice,
    page.should have_selector '.notice'
    
    # And I should see no option_types.
    page.should have_no_selector '.option_type'
  end
  
  scenario 'I can delete an option type via AJAX', :js => true do
    # When I click the option type's Delete button,
    within '.option_type' do
      click_button 'Delete'
    end
    
    # And I confirm in the modal box,
    accept_confirmation
    
    # Then I should see a notice,
    sleep 0.5 and page.should have_selector '.notice', :text => "Option Type was successfully destroyed."
    
    # And I should see no option_types.
    page.should have_no_selector '.option_type'
  end
end