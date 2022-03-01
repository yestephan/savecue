require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get profiles_home_url
    assert_response :success
  end

  test "should get new" do
    get profiles_new_url
    assert_response :success
  end

  test "should get show" do
    get profiles_show_url
    assert_response :success
  end

  test "should get bank_info" do
    get profiles_bank_info_url
    assert_response :success
  end

  test "should get confirm" do
    get profiles_confirm_url
    assert_response :success
  end
end
