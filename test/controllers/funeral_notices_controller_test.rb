require "test_helper"

class FuneralNoticesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get funeral_notices_index_url
    assert_response :success
  end
end
