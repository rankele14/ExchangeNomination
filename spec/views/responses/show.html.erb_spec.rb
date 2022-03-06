require 'rails_helper'

RSpec.describe "responses/show", type: :view do
  before(:each) do
    @response = assign(:response, Response.create!(
      reply: "Reply",
      question: "",
      student: ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Reply/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
