require 'test_helper'

class V1::CardsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get v1_cards_index_url
    assert_response :success
  end

  test "should get create" do
    get v1_cards_create_url
    assert_response :success
  end

  test "should get show" do
    get v1_cards_show_url
    assert_response :success
  end

  test "should get update" do
    get v1_cards_update_url
    assert_response :success
  end

  test "should get destroy" do
    get v1_cards_destroy_url
    assert_response :success
  end

end
