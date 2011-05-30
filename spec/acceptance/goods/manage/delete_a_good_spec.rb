require File.expand_path( '../../../acceptance_helper', __FILE__ )

feature "Delete a good", %q{
  In order to cull the weaklings
  As an artisan
  I want to delete a good.
} do
  
  background do
    # Given I have created a good
    create_good

    # And I am on the Manage Goods page,
    visit '/manage/goods'
    
    # And I haved clicked the good's Delete button
    within '.good' do
      click_button 'Delete'
    end
  end
  
  scenario "I can delete a good" do  
    # Then I should see a notice
    page.should have_selector '.notice', :text => 'Good was successfully destroyed.'
    
    # And I should not see any goods.
    page.should have_no_selector '.good'
  end
  
  scenario "I can delete a good via AJAX", :js => true do
    # When I confirm in the modal window
    accept_confirmation
    
    # Then I should see a notice
    page.should have_selector '.notice', :text => 'Good was successfully destroyed.'
    
    # And I should not see any goods.
    page.should have_no_selector '.good'
  end
end