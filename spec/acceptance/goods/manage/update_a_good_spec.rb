require File.expand_path( '../../../acceptance_helper', __FILE__ )

feature "Update a good", %q{
  In order to change my good's information
  As an artisan
  I want to update my good.
} do
  
  background do
    # Given I have created a good named 'Gnarlystick'
    create_good :name => 'Gnarlystick'
    
    # And I am on the edit good page for it,
    visit "/goods/gnarlystick/edit"
  end
  
  scenario 'I can update a good with valid information' do
    # When I update my good with valid information and click Update Good,
    fill_in 'Name', :with => 'Greater Gnarlystick'
    click_button 'Update Good'
    
    # Then I should see a notice,
    page.should have_selector '.notice', :text => 'Good was successfully updated.'
    
    # Then I should see my updated good.
    page.should have_content 'Greater Gnarlystick'
  end
  
  scenario 'I cannot update a good with invalid information' do
    # When I update my good with invalid information and click Update Good,
    fill_in 'Name', :with => ''
    click_button 'Update Good'
    
    # Then I should see an alert.
    page.should have_selector '.alert'
  end
end