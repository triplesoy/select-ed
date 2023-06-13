require "test_helper"

class CommunityJoinRequestControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get community_join_request_index_url
    assert_response :success
  end

  test "should get show" do
    get community_join_request_show_url
    assert_response :success
  end

  test "should get new" do
    get community_join_request_new_url
    assert_response :success
  end

  test "should get create" do
    get community_join_request_create_url
    assert_response :success
  end

  test "should get edit" do
    get community_join_request_edit_url
    assert_response :success
  end

  test "should get update" do
    get community_join_request_update_url
    assert_response :success
  end

  test "should get destroy" do
    get community_join_request_destroy_url
    assert_response :success
  end
end
