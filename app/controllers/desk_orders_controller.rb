class DeskOrdersController < ApplicationController
  before_action :set_desk_order, only: [:show, :edit, :update, :destroy]
  #before_action :must_login
  #Para permitir o acesso via aplicativo
  skip_before_action :verify_authenticity_token

  # RECEBE O QRCODE DO APLICATIVO E VERIFICA SE A MESA ESTÁ DISPONÍVEL
  def check_mesa
   verifica_mesa = Qrpoint.where(qrcode: params["numero_da_mesa"])
   if verifica_mesa.present?
     render json: { resultado_api: "A MESA ESTÁ LIVRE" }
   else
     render json: { resultado_api: "A MESA ESTÁ EM USO!" }
   end
   puts 'É AQUI QUE VEM O NUMERO DA MESA >>>>>>>> ' + params["numero_da_mesa"].to_s

  end

  # GET /desk_orders
  # GET /desk_orders.json
  def index
    @desk_orders = DeskOrder.all
  end

  # GET /desk_orders/1
  # GET /desk_orders/1.json
  def show
      @total_items = Item.where(desk_order_id: @desk_order.id).sum(:val_total)
  end

  # GET /desk_orders/new
  def new
    @desk_order = DeskOrder.new
  end

  # GET /desk_orders/1/edit
  def edit
  end

  # POST /desk_orders
  # POST /desk_orders.json
  def create
    @desk_order = DeskOrder.new(desk_order_params)

    respond_to do |format|
      if @desk_order.save
        format.html { redirect_to @desk_order, notice: 'Desk order was successfully created.' }
        format.json { render :show, status: :created, location: @desk_order }
      else
        format.html { render :new }
        format.json { render json: @desk_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /desk_orders/1
  # PATCH/PUT /desk_orders/1.json
  def update
    respond_to do |format|
      if @desk_order.update(desk_order_params)
        format.html { redirect_to @desk_order, notice: 'Desk order was successfully updated.' }
        format.json { render :show, status: :ok, location: @desk_order }
      else
        format.html { render :edit }
        format.json { render json: @desk_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /desk_orders/1
  # DELETE /desk_orders/1.json
  def destroy
    @desk_order.destroy
    respond_to do |format|
      format.html { redirect_to desk_orders_url, notice: 'Desk order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_desk_order
      @desk_order = DeskOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def desk_order_params
      params.require(:desk_order).permit(:number, :total, :form_payment, :status, :qrpoint_id)
    end
end
