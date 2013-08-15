require 'test_helper'

class LevelsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @level = create(:level)
    @user = create(:admin)
    sign_in(@user)
  end

  test "should get index" do
    get :index, game_id: @level.game
    assert_response :success
    assert_not_nil assigns(:levels)
  end

  test "should get new" do
    get :new, game_id: @level.game
    assert_response :success
  end

  test "should create level" do
    assert_difference('Level.count') do
      post :create, game_id: @level.game, level: {  }
    end

    level = assigns(:level)
    assert_redirected_to game_level_path(level.game, level)
  end

  test "should show level" do
    get :show, id: @level, game_id: @level.game
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @level, game_id: @level.game
    assert_response :success
  end

  test "should update level" do
    patch :update, id: @level, game_id: @level.game, level: {  }
    level = assigns(:level)
    assert_redirected_to game_level_path(level.game, level)
  end

  test "should destroy level" do
    assert_difference('Level.count', -1) do
      delete :destroy, id: @level, game_id: @level.game
    end

    assert_redirected_to game_levels_path
  end
end
