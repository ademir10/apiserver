class PagesController < ApplicationController
  def login
  end

  def dashboard
    @desk_orders = DeskOrder.includes(:qrpoint).where(status: 'Em uso').order('qrpoints.description')
    @desk_orders_opened = Qrpoint.where(status: 'Aberta').order(:description)
  end

end
