require 'spec_helper'

describe OptionValue do
  let( :new_option_value ) { OptionValue.new :name        => 'Size',
                                             :option_type => stub_model( OptionType ) }
  
  context "validations: " do   
    it "is valid with valid attributes" do
      new_option_value.should be_valid
    end
     
    it "is not valid without a name" do
      new_option_value.name = nil
      new_option_value.should_not be_valid
    end
    
    it "is not valid without an option type" do
      new_option_value.option_type = nil
      new_option_value.should_not be_valid
    end
  end
  
  context "scopes: " do
    describe "by_option_type_id" do
      it "returns the option values in ascending order by their option type's ID" do
        @ot1 = Factory :option_type
        @ot2 = Factory :option_type
        
        @ov1 = Factory :option_value, :option_type => @ot1
        @ov2 = Factory :option_value, :option_type => @ot2
        @ov3 = Factory :option_value, :option_type => @ot1
        
        OptionValue.by_option_type_id.all.should == [ @ov1, @ov3, @ov2 ]
      end
    end
  end
  
  context "when destroying: " do
    it "cannot be destroyed if it is assigned to any variants" do
      variant = Factory :small_blue_variant
      value   = small
      
      value.destroy.should be_false
      value.errors[ :base ].should include "Can't destroy an option value which is assigned to any variants."
    end
  end
end