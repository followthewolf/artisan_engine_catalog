require File.expand_path( '../../../acceptance_helper', __FILE__ )

feature "Manage my goods", %q{
  In order to perform various functions on my goods as a whole
  As an artisan
  I want to manage my goods.
} do
  
  background do
    # Given I have created three goods
    create_good :name => 'Freeze Ray'
    create_good :name => 'Death Ray'
    create_good :name => 'Manta Ray'
    
    # And I am on the Manage Goods page,
    visit '/manage/goods'
  end
  
  scenario "I can view all my goods" do
    # Then I should see my goods
    page.should have_content 'Freeze Ray'
    page.should have_content 'Death Ray'
    page.should have_content 'Manta Ray'
  end
end