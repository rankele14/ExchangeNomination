require 'rails_helper'

RSpec.describe "responses/edit", type: :view do
  before(:each) do
    @response = assign(:response, Response.create!(
      reply: "MyString",
      question: "",
      student: ""
    ))
  end

  it "renders the edit response form" do
    render

    assert_select "form[action=?][method=?]", response_path(@response), "post" do

      assert_select "input[name=?]", "response[reply]"

      assert_select "input[name=?]", "response[question]"

      assert_select "input[name=?]", "response[student]"
    end
  end
end
