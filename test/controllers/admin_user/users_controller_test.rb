require "test_helper"

class AdminUser::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_user_users_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_user_users_show_url
    assert_response :success
  end

  test "should get new" do
    get admin_user_users_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_user_users_edit_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_user_users_destroy_url
    assert_response :success
  end
end
