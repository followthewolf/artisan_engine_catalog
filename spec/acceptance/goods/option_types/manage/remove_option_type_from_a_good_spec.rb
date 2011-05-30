require File.expand_path( '../../../../acceptance_helper', __FILE__ )

feature "Remove an option type from a good", %q{
  In order to remove variation possibilites from a good
  As an artisan
  I want to remove an option type from my good.
} do
  
  background do
    # Given I have created two option types,
    create_option_type 'Size'
    create_option_type 'Color'
    
    # And I have created one good,
    create_good :name => 'Gnarlystick'
    
    # And I have added my option types to my good
    add_option_type 'Size',  :to => 'Gnarlystick'
    add_option_type 'Color', :to => 'Gnarlystick'
    
    # And I am on the Edit Good page for the good,
    visit "/goods/gnarlystick/edit"
  end

  scenario "Remove option types from my good" do
    # When I uncheck Size and Color and click Update Good,
    uncheck        'Size'
    uncheck        'Color'
    
    click_button 'Update Good'
    
    # Then I should see a notice
    page.should have_selector '.notice'

    # And Size and Color should be unchecked.
    within '#option_types_for_good' do
      page.should have_no_selector 'input[checked="checked"]'
    end
  end
end