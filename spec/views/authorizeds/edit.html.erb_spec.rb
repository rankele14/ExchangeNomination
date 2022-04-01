require 'rails_helper'

RSpec.describe "authorizeds/edit", type: :view do
  before(:each) do
    @authorized = assign(:authorized, Authorized.create!(
      authorized_email: "MyString"
    ))
  end

  it "renders the edit authorized form" do
    render

    assert_select "form[action=?][method=?]", authorized_path(@authorized), "post" do

      assert_select "input[name=?]", "authorized[authorized_email]"
    end
  end
end
