class PagesController < ApplicationController
  def login
  end

  def dashboard
    @desk_orders = DeskOrder.includes(:qrpoint).where(status: 'Em uso').or(DeskOrder.includes(:qrpoint).where(status: 'Solicita o fechamento')).order('qrpoints.description')
    @desk_orders_opened = Qrpoint.where(status: 'Aberta').order(:description)
  end

  def message_error_relation_tables
    #chama a mensagem informando que não pode excluir um cadastro com relacionamento em outra tabela
  end

end
