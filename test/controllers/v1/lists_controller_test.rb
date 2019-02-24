require 'test_helper'

class V1::ListsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get v1_lists_index_url
    assert_response :success
  end

  test "should get create" do
    get v1_lists_create_url
    assert_response :success
  end

  test "should get show" do
    get v1_lists_show_url
    assert_response :success
  end

  test "should get update" do
    get v1_lists_update_url
    assert_response :success
  end

  test "should get destroy" do
    get v1_lists_destroy_url
    assert_response :success
  end

  test "should get assign_member" do
    get v1_lists_assign_member_url
    assert_response :success
  end

  test "should get unassign_member" do
    get v1_lists_unassign_member_url
    assert_response :success
  end

end
