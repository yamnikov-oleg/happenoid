require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get enter" do
    get :enter
    assert_response :success
  end

  test "should get exit" do
    get :exit
    assert_response :success
  end

end
