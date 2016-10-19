require 'test_helper'

class PlayerPoolControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get player_pool_index_url
    assert_response :success
  end

  test "should get create" do
    get player_pool_create_url
    assert_response :success
  end

  test "should get import" do
    get player_pool_import_url
    assert_response :success
  end

  test "should get delete" do
    get player_pool_delete_url
    assert_response :success
  end

end
