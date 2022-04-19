require "application_system_test_case"

class NominatorsTest < ApplicationSystemTestCase
  setup do
    @nominator = nominators(:one)
  end

  test "visiting the index" do
    visit nominators_url
    assert_selector "h1", text: "Nominators"
  end

  test "creating a Nominator" do
    visit nominators_url
    click_on "New Nominator"

    fill_in "First name", with: @nominator.first_name
    fill_in "Last name", with: @nominator.last_name
    fill_in "Title", with: @nominator.title
    fill_in "University", with: @nominator.university_id
    click_on "Create Nominator"

    assert_text "Nominator was successfully created"
    click_on "Back"
  end

  test "updating a Nominator" do
    visit nominators_url
    click_on "Edit", match: :first

    fill_in "First name", with: @nominator.first_name
    fill_in "Last name", with: @nominator.last_name
    fill_in "Title", with: @nominator.title
    fill_in "University", with: @nominator.university_id
    click_on "Update Nominator"

    assert_text "Nominator was successfully updated"
    click_on "Back"
  end

  test "destroying a Nominator" do
    visit nominators_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Nominator was successfully destroyed"
  end
end
