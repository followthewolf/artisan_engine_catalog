require 'spec_helper'

describe Good do
  let( :new_good )      { Good.new :sku           => 'TEST-01',
                                   :name          => 'Test Good',
                                   :description   => 'This is a test good.',
                                   :price         => '$25.00' }
 
  let( :existing_good ) { Factory :good }

  context "validations: " do
    it "is valid with valid attributes" do
      new_good.should be_valid
    end
    
    it "is not valid without a SKU" do
      new_good.sku = nil
      new_good.should_not be_valid
    end
    
    it "is not valid with a non-unique SKU (unless the non-unique SKU belongs to its master variant)" do
      duplicate_sku_good = Factory :good
      new_good.sku = duplicate_sku_good.sku
      
      new_good.should_not be_valid
    end
    
    it "is not valid without a name" do
      new_good.name = nil
      new_good.should_not be_valid
    end
  
    it "is not valid without a description" do
      new_good.description = nil
      new_good.should_not be_valid
    end
  
    it "is not valid without a price" do
      new_good.price = nil
      new_good.should_not be_valid
    end
    
    it "is not valid without a price greater than 0" do
      for invalid_price in [ 0, 0.001 ]
        new_good.price = invalid_price
        new_good.should_not be_valid
      end
    end
  end
  
  context "attributes: " do
    describe "price" do
      it "converts to a Money object" do
        new_good.price = "$21.00"
        
        new_good.price.should be_a Money
        new_good.price.to_f.should == 21.0
      end
    end
  end
  
  context "when destroying: " do
    it "destroys all its variants, including master variant" do
      sized_good = Factory :good_with_size_and_color
      sized_good.variants.create!( Factory.attributes_for :variant, :option_values => [ small, blue ] )
      
      lambda {
        sized_good.destroy
      }.should change( Variant, :count ).by( -2 )
    end
  end
      
  context "option type management: " do
    context "if the good has any variants" do
      before do
        @good = Factory :good_with_size_and_color
        @good.variants.create!( Factory.attributes_for :variant, :option_values => [ small, blue ] )
      end
    
      it "will not add a new option type" do
        new_option_type = Factory :option_type
      
        expect {
          @good.option_types << new_option_type
        }.to raise_error RuntimeError, "Can't change option types on a good with variants."
      end
      
      it "will not remove an option type" do
        expect {
          @good.option_type_ids = [ nil ]
        }.to raise_error RuntimeError, "Can't change option types on a good with variants."
      end
    end
  end
  
  describe "master variant management: " do
    context "after creation: " do
      it "creates a master variant with its SKU and Price" do
        new_good.save
      
        new_good.master_variant.sku.should    == new_good.sku
        new_good.master_variant.price.should  == new_good.price
      end
    end
  
    context "after find: " do
      it "initializes its SKU and Price to its master variant's SKU and Price" do
        existing_good.price.should  == existing_good.master_variant.price
        existing_good.sku.should    == existing_good.master_variant.sku
      end
    end
  
    context "after update: " do
      it "updates the master variant's SKU and Price" do
        existing_good.update_attributes :sku   => 'NEW-SKU', 
                                        :price => 25

        existing_good.master_variant.price.should == 25
        existing_good.master_variant.sku.should   == 'NEW-SKU'
      end
    end
  end
end