require 'spec_helper'

describe Representative do
  it "shows the display name" do
    rep = Representative.create(:first_name => "Donald", :last_name => "Duck")
    rep.display_name.should == "Duck, Donald"
  end
end
