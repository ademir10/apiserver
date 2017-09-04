class ItemsController < ApplicationController
  before_action :must_login

  #para autocompletar o nome do produto
  autocomplete :product, :name
  # GET /items
  # GET /items.json
  def index
    @items = Item.all
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @desk_order = DeskOrder.find(params[:desk_order_id])
    if item_params[:product_id].blank?
       sweetalert_warning('Selecione o produto que deseja adicionar!', 'Atenção!')
       redirect_to desk_order_path(@desk_order) and return
     end
   #verifica se no campo do valor unitário foi digitado incorretamente
    if item_params[:val_unit].to_s == 'NaN'
       sweetalert_warning('O valor unitário do produto foi informado incorretamente, verifique os dados!', 'Atenção!')
       redirect_to desk_order_path(@desk_order) and return
     end


       if item_params[:qnt].blank?
         sweetalert_warning('Informe uma quantidade para o produto!', 'Atenção!')
      redirect_to desk_order_path(@desk_order) and return
      else
       @item = @desk_order.items.create(item_params)

         total_itens_atualizado = Item.where(desk_order_id: params[:desk_order_id]).sum(:val_total)

       redirect_to desk_order_path(@desk_order)
      end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy

    @desk_order = DeskOrder.find(params[:desk_order_id])
    @item = @desk_order.items.find(params[:id])
    @item.destroy

    sum_items = Item.where(desk_order_id: params[:desk_order_id].to_i).sum(:val_total)
    DeskOrder.update(params[:desk_order_id].to_i, total: sum_items.to_f)
    redirect_to desk_order_path(@desk_order)
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:product_id, :desk_order_id, :qnt, :val_unit, :val_total, :status, :name_prod, :status)
    end
end
