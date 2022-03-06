require 'rails_helper'

RSpec.describe "responses/index", type: :view do
  before(:each) do
    assign(:responses, [
      Response.create!(
        reply: "Reply",
        question: "",
        student: ""
      ),
      Response.create!(
        reply: "Reply",
        question: "",
        student: ""
      )
    ])
  end

  it "renders a list of responses" do
    render
    assert_select "tr>td", text: "Reply".to_s, count: 2
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: "".to_s, count: 2
  end
end
