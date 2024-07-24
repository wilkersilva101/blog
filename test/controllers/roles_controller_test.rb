require "test_helper"

class RolesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get roles_index_url
    assert_response :success
  end

  test "should get edit" do
    get roles_edit_url
    assert_response :success
  end

  test "should get update" do
    get roles_update_url
    assert_response :success
  end
end
