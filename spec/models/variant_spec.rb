require 'spec_helper'

describe Variant do
  let( :new_variant ) { Variant.new :sku           => 'VAR-01',
                                    :price         => 45,
                                    :good          => Factory( :good_with_size_and_color ),
                                    :option_values => [ small, blue ] }

  context "validations:" do
    it "is valid with valid attributes" do
      new_variant.should be_valid
    end
    
    it "is not valid without a good" do
      new_variant.good = nil
      new_variant.should_not be_valid
    end
  
    it "is not valid without a SKU" do
      new_variant.sku = nil
      new_variant.should_not be_valid
    end
    
    it "is not valid with a non-unique SKU" do
      duplicate_sku_variant = Factory( :good ).master_variant
      
      new_variant.sku = duplicate_sku_variant.sku
      new_variant.should_not be_valid
    end
  
    it "is not valid without a price" do
      new_variant.price = nil
      new_variant.should_not be_valid
    end
    
    it "is not valid without a price greater than 0" do
      for invalid_price in [ 0, 0.001 ]
        new_variant.price = invalid_price
        new_variant.should_not be_valid
      end
    end
    
    it "is not valid if a variant with matching option values exists" do
      good             = Factory :good_with_size_and_color      
      existing_variant = Factory :small_blue_variant, :good => good
      
      new_variant      = Factory.build :small_blue_variant, :good => good
      
      new_variant.should_not be_valid
      new_variant.errors[ :base ].should include "A variant already exists with this combination of option values."
    end
    
    it "is valid if the variant with matching option values is itself" do
      existing_variant = Factory :small_blue_variant
      existing_variant.should be_valid
    end
  end

  context "option value management:" do
    let( :good ) { Factory :good_with_size_and_color }
    
    it "is not valid without an option value from each of its good's option types (unless it is a master variant)" do
      variant = Factory.build :variant, :good => good
      variant.option_values = [ small ]
      
      # Not valid without a Color.
      variant.should_not be_valid
      variant.errors[ :base ].should include "A variant must have an option value from each of its good's option types."
    
      # Valid with a Color.
      variant.option_values += [ blue ]
      variant.should be_valid
      
      # Master variant skips this validation.
      good.master_variant.should be_valid
    end
    
    it "cannot have more than one option value from any option type" do
      expect {
        Factory :variant, :good => good, :option_values => [ small, large ]
      }.to raise_error RuntimeError, "A variant can't have more than one option value for each of its good's option types."
    end
  end

  describe "#option_value_for" do
    let( :variant ) { Factory :small_blue_variant }
    let( :size )    { OptionType.find_by_name 'Size' }
    
    it "returns the assigned option value for the given option type" do
      variant.option_value_for( size ).should == small
    end
    
    it "returns nil if no option value is found" do
      variant.option_value_for( stub_model OptionType ).should == nil
    end
  end
  
  describe "#option_values_to_s" do
    before do
      @variant               = Factory :small_blue_variant
      massive                = size.option_values.create! :name => 'Massive'
      @variant.option_values = [ green, massive ]
    end
      
    it "constructs a string from its option values, ordered by option type ID" do
      @variant.option_values_to_s.should == 'Size: Massive / Color: Green'
    end
  end
      
  describe "Variant#find_by_good_and_option_values" do
    before do
      @good    = Factory :good_with_size_and_color
      @variant = Factory :small_blue_variant, :good => @good
    end
    
    it "returns the variant with the given good ID and option value IDs" do
      Variant.find_by_good_and_option_values( @good.id, [ small.id, blue.id ] )
             .should == @variant
    end
    
    it "returns nil if no variant is found" do
      Variant.find_by_good_and_option_values( @good.id, [ 1337 ] )
             .should == nil
    end
  end
  
  describe "Variant#option_value_for" do
    let( :variant ) { Factory :small_blue_variant }

    it "returns the assigned option value for the given variant and option type" do
      Variant.option_value_for( variant, size ).should == small
    end

    it "returns nil if no option value is found" do
      Variant.option_value_for( variant, stub_model( OptionType ) ).should == nil
    end
  end
end