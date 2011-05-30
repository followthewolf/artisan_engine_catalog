require File.expand_path( '../../../../acceptance_helper', __FILE__ )

feature "Add an image to a good", %q{
  In order to designate images for my goods
  As an artisan
  I want to attach a new image to a good.
} do
  
  background do
    # Given I have created a good,
    create_good
  end
  
  scenario "I can attach a new image to my good" do
    # When I attach an image to my good
    # ( Attachments: Attach an Image to an Attachable )
    attach_test_image_to Good.first
  
    # Then I should see my image
    page.should have_selector '.image img'
  end
end