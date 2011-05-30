require File.expand_path( '../../../../acceptance_helper', __FILE__ )

feature "Add an option type to a good", %q{
  In order to add variation possibilites to a good
  As an artisan
  I want to add an option type to my good.
} do
  
  background do
    # Given I have created two option types,
    create_option_type 'Size'
    create_option_type 'Color'
    
    # And I have created one good,
    create_good :name => 'Gnarlystick'
    
    # And I am on the Edit Good page for the good,
    visit "/goods/gnarlystick/edit"
  end

  scenario "I can add an option type to my good" do
    # When I check Size and Color and click Update Good,
    check        'Size'
    check        'Color'
    
    click_button 'Update Good'
    
    # Then I should see a notice
    page.should have_selector '.notice'

    # And I should see Size and Color still checked.
    within '#option_types_for_good' do
      page.should have_selector 'input[checked="checked"]', :count => 2
    end
  end
  
  scenario "I cannot modify option types on a good with variants" do
    # Given I have added an option type and a variant to the good,
    create_option_value 'Size', 'Small'
    add_option_type     'Size', :to => 'Gnarlystick'
    create_variant_for  'Gnarlystick', :values => { :size => 'Small' }
    
    # When I visit the edit good page for the good,
    visit "/goods/gnarlystick/edit"
    
    # Then the option type check-boxes should not appear.
    page.should have_no_selector '#option_types_for_good'
  end
end