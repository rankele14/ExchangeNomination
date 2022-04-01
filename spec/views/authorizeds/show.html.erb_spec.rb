require 'rails_helper'

RSpec.describe "authorizeds/show", type: :view do
  before(:each) do
    @authorized = assign(:authorized, Authorized.create!(
      authorized_email: "Authorized Email"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Authorized Email/)
  end
end
