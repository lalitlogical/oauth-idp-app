require "test_helper"

class Admin::ApplicationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_applications_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_applications_show_url
    assert_response :success
  end

  test "should get new" do
    get admin_applications_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_applications_edit_url
    assert_response :success
  end
end
