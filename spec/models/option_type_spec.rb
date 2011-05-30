require 'spec_helper'

describe OptionType do
  let( :new_option_type )      { OptionType.new :name => 'Size' }
  let( :existing_option_type ) { Factory :option_type }
  
  it "is valid with valid attributes" do
    new_option_type.should be_valid
  end
  
  context "validations: " do
    it "is not valid without a name" do
      new_option_type.name = nil
      new_option_type.should_not be_valid
    end
  end
  
  context "when destroying: " do
    it "destroys all associated option values" do
      existing_option_type.option_values << Factory( :option_value )
      
      lambda {
        existing_option_type.destroy
      }.should change( OptionValue, :count ).by( -1 )
    end
    
    it "cannot be destroyed if it is assigned to any goods" do
      existing_option_type.goods << Factory( :good )
      existing_option_type.destroy.should be_false
      existing_option_type.errors[ :base ].should include "Can't destroy an option type which is assigned to any goods."
    end
  end
end