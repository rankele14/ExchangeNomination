require 'rails_helper'

RSpec.describe "authorizeds/new", type: :view do
  before(:each) do
    assign(:authorized, Authorized.new(
      authorized_email: "MyString"
    ))
  end

  it "renders new authorized form" do
    render

    assert_select "form[action=?][method=?]", authorizeds_path, "post" do

      assert_select "input[name=?]", "authorized[authorized_email]"
    end
  end
end
