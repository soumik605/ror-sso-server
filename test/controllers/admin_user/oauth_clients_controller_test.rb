require "test_helper"

class AdminUser::OauthClientsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_user_oauth_clients_index_url
    assert_response :success
  end
end
