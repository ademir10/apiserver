class ItemsController < ApplicationController
  before_action :must_login

  #form modal para editar tributos
    def editar_tributo
    @item = Item.find_by(id: params[:id])
    @produto = Product.find_by(id: @item.product_id)
    @cfops = Cfop.order(:codigo)
    respond_to do |format|
    format.html
    format.js
    end
  end

  #para autocompletar o nome do produto
  autocomplete :product, :name
  # GET /items
  # GET /items.json
  def index
    @items = Item.all
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
    @item = Item.find(params[:id])
    @desk_order = DeskOrder.find(@item.desk_order_id)

    if item_params[:codigo_ncm].blank?
      sweetalert_warning('O campo NCM do item: ' + @item.product.name.to_s + ' não pode ficar em branco, informe o Código com 8 digitos caso queira emitir um documento fiscal posteriormente!', 'Atenção', persistent: 'OK')
    end
    #quando é marcado para aplicar os impostos de uma só vez em todos os itens da venda
    if item_params[:apply_all] == '1'
         Item.where('desk_order_id = ?', @item.desk_order_id).update_all(cfop: item_params[:cfop], icms_situacao_tributaria: item_params[:icms_situacao_tributaria])
         redirect_to desk_order_path(@desk_order) and return
    end
    if @item.update(item_params)
       @item = @desk_order.items.find(params[:id])
     redirect_to desk_order_path(@desk_order)
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
      params.require(:item).permit(:product_id, :desk_order_id, :qnt, :val_unit, :val_total, :status, :name_prod, :status, :qrpoint_name, :local_print, :cfop, :codigo_ncm, :icms_situacao_tributaria, :apply_all)
    end
end
