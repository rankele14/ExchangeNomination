require 'rails_helper'

RSpec.describe "answers/index", type: :view do
  before(:each) do
    assign(:answers, [
      Answer.create!(
        choice: "Choice",
        question: ""
      ),
      Answer.create!(
        choice: "Choice",
        question: ""
      )
    ])
  end

  it "renders a list of answers" do
    render
    assert_select "tr>td", text: "Choice".to_s, count: 2
    assert_select "tr>td", text: "".to_s, count: 2
  end
end
