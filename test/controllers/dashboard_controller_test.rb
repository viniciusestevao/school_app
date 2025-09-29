require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  def setup
    sign_in users(:one)
  end

  test "should get index" do
    get dashboard_index_url
    assert_response :success
  end
end
