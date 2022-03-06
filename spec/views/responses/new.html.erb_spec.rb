require 'rails_helper'

RSpec.describe "responses/new", type: :view do
  before(:each) do
    assign(:response, Response.new(
      reply: "MyString",
      question: "",
      student: ""
    ))
  end

  it "renders new response form" do
    render

    assert_select "form[action=?][method=?]", responses_path, "post" do

      assert_select "input[name=?]", "response[reply]"

      assert_select "input[name=?]", "response[question]"

      assert_select "input[name=?]", "response[student]"
    end
  end
end
