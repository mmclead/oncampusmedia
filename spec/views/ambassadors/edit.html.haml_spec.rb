require 'spec_helper'

describe "ambassadors/edit" do
  before(:each) do
    @ambassador = assign(:ambassador, stub_model(Ambassador,
      :name => "MyString",
      :address => "MyString",
      :city => "MyString",
      :state => "MyString",
      :zip => "MyString"
    ))
  end

  it "renders the edit ambassador form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", ambassador_path(@ambassador), "post" do
      assert_select "input#ambassador_name[name=?]", "ambassador[name]"
      assert_select "input#ambassador_address[name=?]", "ambassador[address]"
      assert_select "input#ambassador_city[name=?]", "ambassador[city]"
      assert_select "input#ambassador_state[name=?]", "ambassador[state]"
      assert_select "input#ambassador_zip[name=?]", "ambassador[zip]"
    end
  end
end
