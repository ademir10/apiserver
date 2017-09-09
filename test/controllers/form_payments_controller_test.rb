require 'test_helper'

class FormPaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @form_payment = form_payments(:one)
  end

  test "should get index" do
    get form_payments_url
    assert_response :success
  end

  test "should get new" do
    get new_form_payment_url
    assert_response :success
  end

  test "should create form_payment" do
    assert_difference('FormPayment.count') do
      post form_payments_url, params: { form_payment: { type_payment: @form_payment.type_payment } }
    end

    assert_redirected_to form_payment_url(FormPayment.last)
  end

  test "should show form_payment" do
    get form_payment_url(@form_payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_form_payment_url(@form_payment)
    assert_response :success
  end

  test "should update form_payment" do
    patch form_payment_url(@form_payment), params: { form_payment: { type_payment: @form_payment.type_payment } }
    assert_redirected_to form_payment_url(@form_payment)
  end

  test "should destroy form_payment" do
    assert_difference('FormPayment.count', -1) do
      delete form_payment_url(@form_payment)
    end

    assert_redirected_to form_payments_url
  end
end
