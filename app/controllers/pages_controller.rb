class PagesController < ApplicationController
  def login
  end

  def dashboard
    @desk_orders = DeskOrder.where(status: 'Aberta').order(:created_at)
    @desk_orders_opened = Qrpoint.where(status: 'Aberta').order(:created_at)
  end

end
