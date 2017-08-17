require 'test_helper'

class QrpointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @qrpoint = qrpoints(:one)
  end

  test "should get index" do
    get qrpoints_url
    assert_response :success
  end

  test "should get new" do
    get new_qrpoint_url
    assert_response :success
  end

  test "should create qrpoint" do
    assert_difference('Qrpoint.count') do
      post qrpoints_url, params: { qrpoint: { description: @qrpoint.description, qrcode: @qrpoint.qrcode, status: @qrpoint.status } }
    end

    assert_redirected_to qrpoint_url(Qrpoint.last)
  end

  test "should show qrpoint" do
    get qrpoint_url(@qrpoint)
    assert_response :success
  end

  test "should get edit" do
    get edit_qrpoint_url(@qrpoint)
    assert_response :success
  end

  test "should update qrpoint" do
    patch qrpoint_url(@qrpoint), params: { qrpoint: { description: @qrpoint.description, qrcode: @qrpoint.qrcode, status: @qrpoint.status } }
    assert_redirected_to qrpoint_url(@qrpoint)
  end

  test "should destroy qrpoint" do
    assert_difference('Qrpoint.count', -1) do
      delete qrpoint_url(@qrpoint)
    end

    assert_redirected_to qrpoints_url
  end
end
