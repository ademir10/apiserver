require 'test_helper'

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payment = payments(:one)
  end

  test "should get index" do
    get payments_url
    assert_response :success
  end

  test "should get new" do
    get new_payment_url
    assert_response :success
  end

  test "should create payment" do
    assert_difference('Payment.count') do
      post payments_url, params: { payment: { description: @payment.description, doc_number: @payment.doc_number, due_date: @payment.due_date, form_payment: @payment.form_payment, installments: @payment.installments, payment_date: @payment.payment_date, status: @payment.status, supplier_id: @payment.supplier_id, type_doc: @payment.type_doc, value_doc: @payment.value_doc } }
    end

    assert_redirected_to payment_url(Payment.last)
  end

  test "should show payment" do
    get payment_url(@payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_payment_url(@payment)
    assert_response :success
  end

  test "should update payment" do
    patch payment_url(@payment), params: { payment: { description: @payment.description, doc_number: @payment.doc_number, due_date: @payment.due_date, form_payment: @payment.form_payment, installments: @payment.installments, payment_date: @payment.payment_date, status: @payment.status, supplier_id: @payment.supplier_id, type_doc: @payment.type_doc, value_doc: @payment.value_doc } }
    assert_redirected_to payment_url(@payment)
  end

  test "should destroy payment" do
    assert_difference('Payment.count', -1) do
      delete payment_url(@payment)
    end

    assert_redirected_to payments_url
  end
end
