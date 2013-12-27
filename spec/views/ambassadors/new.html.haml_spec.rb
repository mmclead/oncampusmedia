require 'spec_helper'

describe "ambassadors/new" do
  before(:each) do
    assign(:ambassador, stub_model(Ambassador,
      :name => "MyString",
      :address => "MyString",
      :city => "MyString",
      :state => "MyString",
      :zip => "MyString"
    ).as_new_record)
  end

  it "renders new ambassador form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", ambassadors_path, "post" do
      assert_select "input#ambassador_name[name=?]", "ambassador[name]"
      assert_select "input#ambassador_address[name=?]", "ambassador[address]"
      assert_select "input#ambassador_city[name=?]", "ambassador[city]"
      assert_select "input#ambassador_state[name=?]", "ambassador[state]"
      assert_select "input#ambassador_zip[name=?]", "ambassador[zip]"
    end
  end
end
