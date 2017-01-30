require 'test_helper'

class HoldingsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get holdings_new_url
    assert_response :success
  end

end
