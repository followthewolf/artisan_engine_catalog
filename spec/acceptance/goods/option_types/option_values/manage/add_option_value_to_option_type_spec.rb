require File.expand_path( '../../../../../acceptance_helper', __FILE__ )

feature 'Add an option value to an option type', %q{
  In order to designate what kinds of options my goods can have
  As an artisan
  I want to add an option value to an option type.
} do
  
  background do
    # Given I am on the Manage Option Types page,
    visit '/manage/option_types'
    
    # And I have created an Option Type named Size
    create_option_type 'Size'
  
    # And I click the Add Option Value link within my option type
    within '.option_type' do
      click_link 'Add Option Value'
    end
  end
  
  scenario 'I can add an option value with valid attributes to an option type' do
    # When I fill in Name with Small and click Create Option Value,
    create_option_value 'Size', 'Small'
    
    # Then I should see a notice,
    page.should have_selector '.notice'
    
    # And I should see my new option value within my option type.
    within '.option_type' do
      page.should have_selector '.option_value', :text => 'Small'
    end
  end
  
  scenario 'I cannot add an option value with invalid attributes to an option type' do
    # When I fill in Name with nothing and click Create Option Value,
    fill_in 'Name', :with => ''
    click_button 'Create Option Value'
    
    # Then I should see an alert,
    page.should have_selector '.alert', :text => 'Option Value could not be saved.'
  end
end