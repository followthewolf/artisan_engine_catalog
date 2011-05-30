require File.expand_path( '../../../acceptance_helper', __FILE__ )

feature "Create a good", %q{
  In order to populate my catalog with goods
  As an artisan
  I want to create a good.
} do
  
  background do
    # Given I am on the New Good page,
    visit '/goods/new'
  end

  scenario "I can create a good with valid attributes" do
    # When I fill in valid basic information for the good and click Create Good,
    create_good :name => 'Illustrious Boot Cuff of Champions'
    
    # Then I should see my new good.
    page.should have_content 'Illustrious Boot Cuff of Champions'
  end
  
  scenario "I cannot create a good with invalid attributes" do
    # When I fill in invalid basic information for the good and click Create Good,
    fill_in 'SKU',          :with => ''
    fill_in 'Name',         :with => ''
    fill_in 'Description',  :with => ''
    fill_in 'Price',        :with => -25
      
    click_button 'Create Good'
    
    # Then I should see an alert,
    page.should have_selector '.alert'
    
    # And there should be no goods.
    Good.count.should == 0
  end
end