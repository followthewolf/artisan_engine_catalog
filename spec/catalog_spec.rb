require 'spec_helper'

describe ArtisanEngine::Catalog do
  it "is an Engine" do
    ArtisanEngine::Catalog::Engine.ancestors.should include Rails::Engine
  end
  
  context "includes stylesheet expansions:" do
    context "artisan_engine:" do
      it "artisan_engine/catalog/back" do
        ActionView::Helpers::AssetTagHelper.stylesheet_expansions[ :artisan_engine ]
          .should include "artisan_engine/catalog/back"
      end
    end
    
    context "artisan_engine_front:" do
      it "artisan_engine/catalog/front" do
        ActionView::Helpers::AssetTagHelper.stylesheet_expansions[ :artisan_engine_front ]
          .should include "artisan_engine/catalog/front"
      end
    end
  end
end

describe "ArtisanEngine::Catalog Test/Development Environment" do
  it "initializes ArtisanEngine::Catalog" do
    ArtisanEngine::Catalog.should be_a Module
  end
  
  it "compiles its stylesheets into ArtisanEngine's stylesheets/artisan_engine/catalog directory" do
    Compass.configuration.css_path.should == "#{ ArtisanEngine.root }/lib/generators/artisan_engine/templates/assets/stylesheets/artisan_engine/catalog"
  end
  
  it "does not compile stylesheets during tests" do
    Sass::Plugin.options[ :never_update ].should be_true
  end
  
  it "compiles its javascripts into ArtisanEngine's javascripts/artisan_engine/catalog directory" do
    Barista.output_root.should == Pathname.new( "#{ ArtisanEngine.root }/lib/generators/artisan_engine/templates/assets/javascripts/artisan_engine/catalog" )
  end
end