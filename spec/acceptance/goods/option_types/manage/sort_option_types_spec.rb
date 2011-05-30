require File.expand_path( '../../../../acceptance_helper', __FILE__ )

feature 'Sort Option Types', %q{
  In order to control the display of my option types
  As an artisan
  I want to sort my option types.
} do
  
  scenario "Sort my option types" do
    # This is a cheater spec because I don't know how to make Selenium drag/drop
    # properly. 
    
    # It just tests that OptionType is properly integrated with Listability
    # and assumes that the JS parameters are being sent properly.
    
    # If something goes wrong, check to make sure that sortable.serialize is
    # sending properly formatted parameters to the controller.
    
    # Given I have three option types,
    @option_type1 = OptionType.create! :name => 'Size'
    @option_type2 = OptionType.create! :name => 'Color'
    @option_type3 = OptionType.create! :name => 'Material'
    
    # When I sort my option types,
    page.driver.post '/sort/option_types', :option_type => [ "#{ @option_type3.id }",
                                                             "#{ @option_type2.id }", 
                                                             "#{ @option_type1.id }" ]
    
    # And I visit the manage option types page,
    visit '/manage/option_types'
    
    # Then my option types should be in their sorted order.
    all( '.option_type' )[0].text.should =~ /Material/
    all( '.option_type' )[1].text.should =~ /Color/
    all( '.option_type' )[2].text.should =~ /Size/
  end
end