require "test_helper"

class CommunityUserControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get community_user_index_url
    assert_response :success
  end

  test "should get show" do
    get community_user_show_url
    assert_response :success
  end

  test "should get new" do
    get community_user_new_url
    assert_response :success
  end

  test "should get create" do
    get community_user_create_url
    assert_response :success
  end

  test "should get edit" do
    get community_user_edit_url
    assert_response :success
  end

  test "should get update" do
    get community_user_update_url
    assert_response :success
  end

  test "should get destroy" do
    get community_user_destroy_url
    assert_response :success
  end
end
