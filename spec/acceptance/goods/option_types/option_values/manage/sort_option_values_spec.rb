require File.expand_path( '../../../../../acceptance_helper', __FILE__ )

feature 'Sort Option Values', %q{
  In order to control the display of my option values
  As an artisan
  I want to sort my option values.
} do
  
  scenario "I can sort my option type's option values" do
    # This is a cheater spec because I don't know how to make Selenium drag/drop
    # properly. 
    
    # It just tests that OptionValue is properly integrated with Listability
    # and assumes that the JS parameters are being sent properly.
    
    # If something goes wrong, check to make sure that sortable.serialize is
    # sending properly formatted parameters to the controller.
    
    # Given I have an option type and three option values,
    @option_type   = OptionType.create! :name => 'Size'

    @option_value1 = @option_type.option_values.create! :name => 'Small'
    @option_value2 = @option_type.option_values.create! :name => 'Medium'
    @option_value3 = @option_type.option_values.create! :name => 'Large'
    
    # When I sort my option values,
    page.driver.post '/sort/option_values', :option_value => [ "#{ @option_value3.id }",
                                                               "#{ @option_value2.id }", 
                                                               "#{ @option_value1.id }" ]
    
    # And I visit the manage option types page,
    visit '/manage/option_types'
    
    # Then my option values should be in their sorted order.
    all( '.option_value' )[0].text.should =~ /Large/
    all( '.option_value' )[1].text.should =~ /Medium/
    all( '.option_value' )[2].text.should =~ /Small/
  end
end