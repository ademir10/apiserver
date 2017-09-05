class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :doc_number, :type_doc, :description, :due_date, :payment_date, :installments, :value_doc, :form_payment, :status
  has_one :supplier
end
