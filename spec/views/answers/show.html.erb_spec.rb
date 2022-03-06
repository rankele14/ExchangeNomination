require 'rails_helper'

RSpec.describe "answers/show", type: :view do
  before(:each) do
    @answer = assign(:answer, Answer.create!(
      choice: "Choice",
      question: ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Choice/)
    expect(rendered).to match(//)
  end
end
