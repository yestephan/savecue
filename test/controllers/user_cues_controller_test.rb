require "test_helper"

class UserCuesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get user_cues_new_url
    assert_response :success
  end

  test "should get show" do
    get user_cues_show_url
    assert_response :success
  end

  test "should get edit" do
    get user_cues_edit_url
    assert_response :success
  end
end
