require "test_helper"

class CommunityUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get community_users_index_url
    assert_response :success
  end

  test "should get show" do
    get community_users_show_url
    assert_response :success
  end

  test "should get new" do
    get community_users_new_url
    assert_response :success
  end

  test "should get create" do
    get community_users_create_url
    assert_response :success
  end

  test "should get edit" do
    get community_users_edit_url
    assert_response :success
  end

  test "should get update" do
    get community_users_update_url
    assert_response :success
  end

  test "should get destroy" do
    get community_users_destroy_url
    assert_response :success
  end
end
