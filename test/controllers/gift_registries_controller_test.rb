require 'test_helper'

class GiftRegistriesControllerTest < ActionController::TestCase
  setup do
    @gift_registry = gift_registries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gift_registries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gift_registry" do
    assert_difference('GiftRegistry.count') do
      post :create, gift_registry: { bride_id: @gift_registry.bride_id, id: @gift_registry.id, product_id: @gift_registry.product_id, quantity_requested: @gift_registry.quantity_requested, quantity_reserved: @gift_registry.quantity_reserved }
    end

    assert_redirected_to gift_registry_path(assigns(:gift_registry))
  end

  test "should show gift_registry" do
    get :show, id: @gift_registry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gift_registry
    assert_response :success
  end

  test "should update gift_registry" do
    patch :update, id: @gift_registry, gift_registry: { bride_id: @gift_registry.bride_id, id: @gift_registry.id, product_id: @gift_registry.product_id, quantity_requested: @gift_registry.quantity_requested, quantity_reserved: @gift_registry.quantity_reserved }
    assert_redirected_to gift_registry_path(assigns(:gift_registry))
  end

  test "should destroy gift_registry" do
    assert_difference('GiftRegistry.count', -1) do
      delete :destroy, id: @gift_registry
    end

    assert_redirected_to gift_registries_path
  end
end
