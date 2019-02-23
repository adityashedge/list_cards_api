require 'test_helper'

class V1::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get v1_sessions_create_url
    assert_response :success
  end

  test "should get destroy" do
    get v1_sessions_destroy_url
    assert_response :success
  end

end
