require 'test_helper'

class DeskOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @desk_order = desk_orders(:one)
  end

  test "should get index" do
    get desk_orders_url
    assert_response :success
  end

  test "should get new" do
    get new_desk_order_url
    assert_response :success
  end

  test "should create desk_order" do
    assert_difference('DeskOrder.count') do
      post desk_orders_url, params: { desk_order: { number: @desk_order.number, status: @desk_order.status, total: @desk_order.total } }
    end

    assert_redirected_to desk_order_url(DeskOrder.last)
  end

  test "should show desk_order" do
    get desk_order_url(@desk_order)
    assert_response :success
  end

  test "should get edit" do
    get edit_desk_order_url(@desk_order)
    assert_response :success
  end

  test "should update desk_order" do
    patch desk_order_url(@desk_order), params: { desk_order: { number: @desk_order.number, status: @desk_order.status, total: @desk_order.total } }
    assert_redirected_to desk_order_url(@desk_order)
  end

  test "should destroy desk_order" do
    assert_difference('DeskOrder.count', -1) do
      delete desk_order_url(@desk_order)
    end

    assert_redirected_to desk_orders_url
  end
end
