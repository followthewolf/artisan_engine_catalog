require File.expand_path( '../../../../acceptance_helper', __FILE__ )

feature "Add an image to a variant", %q{
  In order to designate images for my variants
  As an artisan
  I want to attach a new image to a variant.
} do
  
  background do
    # Given I have created a good with two populated option types,
    create_good_with_populated_option_types

    # And I have created a variant for the good
    create_variant_for 'Cloak of No Particular Color'

    # And I am on the Edit Good page,
    visit "/goods/cloak-of-no-particular-color/edit"
    
    # And I have clicked the variant's Edit link,
    within '.variant' do
      click_link 'Edit'
    end
  end
  
  scenario "I can attach a new image to my variant" do
    # When I attach an image to my good
    # ( Attachments: Attach an Image to an Attachable )
    attach_test_image_to Variant.last, :path => edit_good_variant_path( Variant.last.good, Variant.last )
  
    # Then I should see my image
    page.should have_selector '.image img'
  end
end