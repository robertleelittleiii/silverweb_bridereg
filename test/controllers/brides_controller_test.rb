require 'test_helper'

class BridesControllerTest < ActionController::TestCase
  setup do
    @bride = brides(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:brides)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bride" do
    assert_difference('Bride.count') do
      post :create, bride: { groom_full_name: @bride.groom_full_name, id: @bride.id, user_id: @bride.user_id, wedding_date: @bride.wedding_date }
    end

    assert_redirected_to bride_path(assigns(:bride))
  end

  test "should show bride" do
    get :show, id: @bride
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bride
    assert_response :success
  end

  test "should update bride" do
    patch :update, id: @bride, bride: { groom_full_name: @bride.groom_full_name, id: @bride.id, user_id: @bride.user_id, wedding_date: @bride.wedding_date }
    assert_redirected_to bride_path(assigns(:bride))
  end

  test "should destroy bride" do
    assert_difference('Bride.count', -1) do
      delete :destroy, id: @bride
    end

    assert_redirected_to brides_path
  end
end
