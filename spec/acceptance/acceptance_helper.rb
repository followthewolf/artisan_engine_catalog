require 'spec_helper'
require 'steak'

# ---------------------- Load Support Files ---------------------- #

include ArtisanEngine::Core::TestHelpers::Integration
include ArtisanEngine::Catalog::TestHelpers::Integration
include ArtisanEngine::Attachments::TestHelpers::Integration

Dir[ "#{ File.dirname( __FILE__ ) }/support/**/*.rb" ].each { |f| require f }