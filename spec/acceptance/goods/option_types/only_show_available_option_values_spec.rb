require File.expand_path( '../../../acceptance_helper', __FILE__ )

feature 'Option Types only display available Option Values', %q{
  In order to prevent patrons from seeing unavailable option values for a variant
  As an artisan
  I want option types to only display available option values.
} do
  
  background do
    # Given I have created a good with option types,
    create_good_with_populated_option_types
    
    # And I have only created two variants for the good ( Small, Dull / Small, Brilliant ),
    create_variant_for 'Cloak of No Particular Color', :values => { :size       => 'Small',
                                                                    :luminosity => 'Dull' }
    
    create_variant_for 'Cloak of No Particular Color', :values => { :size       => 'Small',
                                                                    :luminosity => 'Brilliant' }
    
    # And I am on the show good page,
    visit '/goods/cloak-of-no-particular-color'
  end
  
  scenario "I only see available option values in the option type select lists" do
    # Then I should only see Small in the Size option types list,
    within 'select#Size' do
      page.should have_selector 'option', :text => 'Small'
      page.should have_selector 'option', :count => 1
    end
    
    # And I should only see Dull and Brilliant in the Luminosity option types list.
    within 'select#Luminosity' do
      page.should have_selector 'option', :text => 'Dull'
      page.should have_selector 'option', :text => 'Brilliant'
      page.should have_selector 'option', :count => 2
    end
  end
end