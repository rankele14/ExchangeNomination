require 'rails_helper'

RSpec.describe "authorizeds/index", type: :view do
  before(:each) do
    assign(:authorizeds, [
      Authorized.create!(
        authorized_email: "Authorized Email"
      ),
      Authorized.create!(
        authorized_email: "Authorized Email"
      )
    ])
  end

  it "renders a list of authorizeds" do
    render
    assert_select "tr>td", text: "Authorized Email".to_s, count: 2
  end
end
