require 'test_helper'

class LineupsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get lineups_index_url
    assert_response :success
  end

end
