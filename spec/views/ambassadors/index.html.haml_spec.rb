require 'spec_helper'

describe "ambassadors/index" do
  before(:each) do
    assign(:ambassadors, [
      stub_model(Ambassador,
        :name => "Name",
        :address => "Address",
        :city => "City",
        :state => "State",
        :zip => "Zip"
      ),
      stub_model(Ambassador,
        :name => "Name",
        :address => "Address",
        :city => "City",
        :state => "State",
        :zip => "Zip"
      )
    ])
  end

  it "renders a list of ambassadors" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "Zip".to_s, :count => 2
  end
end
