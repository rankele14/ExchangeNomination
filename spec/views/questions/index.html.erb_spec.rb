require 'rails_helper'

RSpec.describe "questions/index", type: :view do
  before(:each) do
    assign(:questions, [
      Question.create!(
        multi: false,
        prompt: "Prompt"
      ),
      Question.create!(
        multi: false,
        prompt: "Prompt"
      )
    ])
  end

  it "renders a list of questions" do
    render
    assert_select "tr>td", text: false.to_s, count: 2
    assert_select "tr>td", text: "Prompt".to_s, count: 2
  end
end
