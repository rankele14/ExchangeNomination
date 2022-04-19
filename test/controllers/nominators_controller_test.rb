require "test_helper"

class NominatorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @nominator = nominators(:one)
  end

  test "should get index" do
    get nominators_url
    assert_response :success
  end

  test "should get new" do
    get new_nominator_url
    assert_response :success
  end

  test "should create nominator" do
    assert_difference('Nominator.count') do
      post nominators_url, params: { nominator: { first_name: @nominator.first_name, last_name: @nominator.last_name, title: @nominator.title, university_id: @nominator.university_id } }
    end

    assert_redirected_to nominator_url(Nominator.last)
  end

  test "should show nominator" do
    get nominator_url(@nominator)
    assert_response :success
  end

  test "should get edit" do
    get edit_nominator_url(@nominator)
    assert_response :success
  end

  test "should update nominator" do
    patch nominator_url(@nominator), params: { nominator: { first_name: @nominator.first_name, last_name: @nominator.last_name, title: @nominator.title, university_id: @nominator.university_id } }
    assert_redirected_to nominator_url(@nominator)
  end

  test "should destroy nominator" do
    assert_difference('Nominator.count', -1) do
      delete nominator_url(@nominator)
    end

    assert_redirected_to nominators_url
  end
end
