require 'test_helper'

class LoginfosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @loginfo = loginfos(:one)
  end

  test "should get index" do
    get loginfos_url
    assert_response :success
  end

  test "should get new" do
    get new_loginfo_url
    assert_response :success
  end

  test "should create loginfo" do
    assert_difference('Loginfo.count') do
      post loginfos_url, params: { loginfo: { employee: @loginfo.employee, task: @loginfo.task } }
    end

    assert_redirected_to loginfo_url(Loginfo.last)
  end

  test "should show loginfo" do
    get loginfo_url(@loginfo)
    assert_response :success
  end

  test "should get edit" do
    get edit_loginfo_url(@loginfo)
    assert_response :success
  end

  test "should update loginfo" do
    patch loginfo_url(@loginfo), params: { loginfo: { employee: @loginfo.employee, task: @loginfo.task } }
    assert_redirected_to loginfo_url(@loginfo)
  end

  test "should destroy loginfo" do
    assert_difference('Loginfo.count', -1) do
      delete loginfo_url(@loginfo)
    end

    assert_redirected_to loginfos_url
  end
end
