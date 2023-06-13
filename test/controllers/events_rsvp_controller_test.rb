require "test_helper"

class EventsRsvpControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get events_rsvp_index_url
    assert_response :success
  end

  test "should get show" do
    get events_rsvp_show_url
    assert_response :success
  end

  test "should get new" do
    get events_rsvp_new_url
    assert_response :success
  end

  test "should get create" do
    get events_rsvp_create_url
    assert_response :success
  end

  test "should get edit" do
    get events_rsvp_edit_url
    assert_response :success
  end

  test "should get update" do
    get events_rsvp_update_url
    assert_response :success
  end

  test "should get destroy" do
    get events_rsvp_destroy_url
    assert_response :success
  end
end
