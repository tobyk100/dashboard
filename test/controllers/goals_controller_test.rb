require 'test_helper'

class GoalsControllerTest < ActionController::TestCase
  setup do
    @goal = create(:goal)
  end

  test "should get index" do
    get :index, provider_id: @goal.provider
    assert_response :success
    assert_not_nil assigns(:goals)
  end

  test "should get new" do
    get :new, provider_id: @goal.provider
    assert_response :success
  end

  test "should create goal" do
    assert_difference('Goal.count') do
      post :create, provider_id: @goal.provider, goal: {  }
    end

    goal = assigns(:goal)
    assert_redirected_to provider_goal_path(goal.provider, goal)
  end

  test "should show goal" do
    get :show, id: @goal, provider_id: @goal.provider
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @goal, provider_id: @goal.provider
    assert_response :success
  end

  test "should update goal" do
    patch :update, id: @goal, provider_id: @goal.provider, goal: {  }
    goal = assigns(:goal)
    assert_redirected_to provider_goal_path(goal.provider, goal)
  end

  test "should destroy goal" do
    assert_difference('Goal.count', -1) do
      delete :destroy, id: @goal, provider_id: @goal.provider
    end

    assert_redirected_to provider_goals_path
  end
end
