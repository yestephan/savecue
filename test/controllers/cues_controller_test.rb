require "test_helper"

class CuesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cues_index_url
    assert_response :success
  end
end
