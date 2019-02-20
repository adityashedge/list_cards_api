require 'test_helper'

class V1::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get v1_registrations_create_url
    assert_response :success
  end

end
