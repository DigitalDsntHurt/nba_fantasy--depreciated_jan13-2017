require 'test_helper'

class PlayerGamesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get player_games_index_url
    assert_response :success
  end

end
