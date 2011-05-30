require File.expand_path( '../../acceptance_helper', __FILE__ )

feature 'View a List of Goods', %q{
  In order to see the artisan's goods at a glance
  As a patron
  I want to view a list of goods.
} do
  
  background do
    # Given the artisan has created three goods,
    for name in %w( Uno Dos Tres )
      create_good :name => name
    end
    
    # And I am on a page that shows a list of goods,
    visit '/list_goods_demo'
  end
  
  scenario "I can view a list of goods" do
    # Then I should see the names of the goods linked to their pages.
    for name in %w( Uno Dos Tres )
      page.should have_selector 'a', :text => name, :href => "/goods/#{ name.downcase }"
    end
  end
end