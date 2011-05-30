require File.expand_path( '../../acceptance_helper', __FILE__ )

feature 'View an Individual Good', %q{
  In order to see a goods in detail
  As a patron
  I want to view an individual good.
} do
  
  background do
    # Given I have created a good,
    create_good :name => 'Bongos', :price => 25
    
    # And I am on the show good page for it,
    visit '/goods/bongos'
  end
  
  scenario "I can view an individual good" do
    # Then I should see the good's name,
    page.should have_content 'Bongos'
    
    # And I should see the good's price,
    page.should have_content '$25.00'
  end
  
  scenario "An individual good shows up properly when it has been assigned an option type with no values" do
    # Given I have created a good with an option type and no option values,
    create_good        :name => 'Bongos'
    create_option_type 'Resonance'
    add_option_type    'Resonance', :to => 'Bongos'
    
    # And I am on the show good page for the good,
    visit '/goods/bongos'
    
    # Then I should see the good displayed.
    page.should have_content 'Bongos'
  end
end