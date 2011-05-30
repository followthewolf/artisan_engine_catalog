require 'spec_helper'

describe GoodsController do
  describe "GET :show" do
    let( :good ) { Factory :good }
    
    context "if no option values parameter is given" do
      context "and the requested good has no variants" do
        before do
          @good = Factory :good
        end
        
        it "assigns @variant with the good's master variant" do
          get :show, :id => @good.id
          assigns( :variant ).should == @good.master_variant
        end
      end
    
      context "and the requested good has any variants" do
        before do
          @good          = Factory :good_with_size_and_color
          @first_variant = Factory :small_blue_variant, :good => @good
        end
        
        it "assigns @variant with the good's first variant" do
          get :show, :id => @good.id
          assigns( :variant ).should == @first_variant
        end
      end
    end
    
    context "if an option values parameter is given" do
      it "attempts to find a variant with the requested good and option values" do
        Variant.should_receive( :find_by_good_and_option_values )
               .with( good.id, [ "1", "5" ] )
        
        get :show, :id => good.id, :option_values => "5x1x"
      end
      
      context "if it finds a variant" do
        let( :found_variant ) { stub_model Variant }
        
        before do
          Variant.stub :find_by_good_and_option_values => found_variant
        end
        
        it "assigns @variant with the found variant" do
          get :show, :id => good.id, :option_values => "5x1x"
          assigns( :variant ).should == found_variant
        end
      end
      
      context "if it does not find a variant" do
        before do
          Variant.stub :find_by_good_and_option_values => nil
        end
        
        it "does not assign @variant" do
          get :show, :id => good.id, :option_values => "5x1x"
          assigns( :variant ).should be_nil
        end
      end
    end
  end
end