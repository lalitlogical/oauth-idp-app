require "test_helper"

class WellKnownControllerTest < ActionDispatch::IntegrationTest
  test "should get openid_configuration" do
    get well_known_openid_configuration_url
    assert_response :success
  end
end
