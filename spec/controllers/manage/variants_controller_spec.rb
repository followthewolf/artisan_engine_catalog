require 'spec_helper'

describe Manage::VariantsController do
  describe "GET :edit" do
    context "if the requested variant is a master variant" do
      let( :good ) { Factory :good }
      
      before do
        Variant.stub( :find ).and_return( good.master_variant )
      end
      
      it "redirects to the variant's good's edit page" do
        get :edit, :good_id => good.id, :id => 1
        response.should redirect_to edit_good_path( good )
      end
    end
  end
end