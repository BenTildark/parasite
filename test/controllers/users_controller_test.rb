require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get email:string" do
    get users_email:string_url
    assert_response :success
  end

  test "should get password_digest:string" do
    get users_password_digest:string_url
    assert_response :success
  end

end
