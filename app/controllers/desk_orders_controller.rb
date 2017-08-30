class DeskOrdersController < ApplicationController
  before_action :set_desk_order, only: [:show, :edit, :update, :destroy]
  before_action :must_login, only: [:show, :edit, :update, :destroy]
  #Para permitir o acesso via aplicativo
  skip_before_action :verify_authenticity_token

  # RECEBE O QRCODE DO APLICATIVO E VERIFICA SE A MESA ESTÁ DISPONÍVEL
  def check_mesa
    #puts 'É AQUI QUE VEM O NUMERO DA MESA >>>>>>>> ' + params["numero_da_mesa"].to_s
      #verifica se o token é valido primeiro
      if params["cardToken"].to_s == 'G0d1$@Bl3T0d0W4Th3V3Rth1Ng'
         @verifica_mesa = Qrpoint.where(qrcode: params["numero_da_mesa"]).first
          if @verifica_mesa.present?
                  if @verifica_mesa.status == 'Aberta'

                      #altera o status da mesa para EM USO e inicia uma venda guardando o id da venda
                      desk_order = DeskOrder.new(params[:desk_order])
                      desk_order.status = 'Em uso'
                      desk_order.qrpoint_id = @verifica_mesa.id
                      desk_order.save!

                      render json: { retorno_rails: "A MESA ESTÁ LIVRE", id_da_mesa: desk_order.id }

                      #após a mesa aberta o status do QRpoint é mudado para Em USO
                      Qrpoint.update(@verifica_mesa.id, status: 'Em uso')
                   elsif @verifica_mesa.status == 'Em uso'
                      render json: { retorno_rails: "A MESA ESTÁ EM USO" }
                   end
         else
           render json: { retorno_rails: "CÓDIGO INVALIDO" }
         end
      #se não confirmar a presença do token a conexão é rejeitada
      else
        render json: { retorno_rails: "ACESSO NEGADO" }
      end
  end

  #ENVIA AS CATEGORIAS DOS PRODUTOS PARA O APLICATIVO
  def list_categories
    @categories = Category.order(:name)
      #aqui é onde eu dou o nome da variavel Json que levará os dados para o aplicativo
      #nesse caso usei uma variavel chamada "categories_product"
      render json: { categories_product: @categories}
  end

  #ENVIA OS PRODUTOS PARA O APLICATIVO COM BASE NA CATEGORIA SELEICIONADA
  def list_products
    #puts 'É AQUI QUE VEM O NUMERO >>>>>>>>' + params["id_da_categoria"].to_s
      if params["cardToken"].to_s == 'G0d1$@Bl3T0d0W4Th3V3Rth1Ng'
      @products = Product.where(category_id: params["id_da_categoria"]).order(:name)
      render json: { all_products: @products}
      end
  end

  #ADICIONA O PRODUTO SELECIONADO NO APP NA MESA aberta
  def add_product

      if params["cardToken"].to_s == 'G0d1$@Bl3T0d0W4Th3V3Rth1Ng'
         product = Product.find(params[:product_id])
         #fazendo o calculo do total multiplicando a quantidade do mesmo item
         val_total_items = params[:qnt_product].to_i * product.value.to_f

          add_item = Item.new(params[:item])
          add_item.desk_order_id = params[:desk_order_id]
          add_item.product_id = params[:product_id]
          add_item.name_prod = product.name
          add_item.qnt = params[:qnt_product]
          add_item.val_unit = product.value
          add_item.val_total = val_total_items
          add_item.save!
          sum_items = Item.where(desk_order_id: params[:desk_order_id].to_i).sum(:val_total)
          DeskOrder.update(params[:desk_order_id].to_i, total: sum_items.to_f)
          render json: { produto_adicionado: product}
      end
  end

  #carrega tudo o que já foi consumido
  def check_order
    if params["cardToken"].to_s == 'G0d1$@Bl3T0d0W4Th3V3Rth1Ng'
      qrpoint_number = DeskOrder.find(params[:desk_order_id])
      desk_name = Qrpoint.find(qrpoint_number.qrpoint_id)
      items_desk_order = Item.where(desk_order_id: params[:desk_order_id].to_i)
      sum_total_items = Item.where(desk_order_id: params[:desk_order_id].to_i).sum(:val_total)
      render json: { mesa_venda: desk_name.description, items_venda: items_desk_order , total_geral: sum_total_items}
      puts 'tudo certo até aqui obrigado Deus!'
    end
  end

  #solicita o fechamento da mesa alterando somente o status da desk_order para "Solicita fechamento"
  def close_order
    if params["cardToken"].to_s == 'G0d1$@Bl3T0d0W4Th3V3Rth1Ng'
      DeskOrder.update(params[:desk_order_id], status: 'Solicita o fechamento')
      puts 'Solicitou o fechamento da conta!'
    end
  end

 #exclui o tem selecionado se ainda não foi enviado para a produção
 def delete_item
    item = Item.find(params[:item_id_app])
      if item.status != 'Em produção'
      item.destroy
        sum_items = Item.where(desk_order_id: params[:desk_order_id].to_i).sum(:val_total)
        DeskOrder.update(params[:desk_order_id].to_i, total: sum_items.to_f)
          puts 'Item excluido pelo aplicativo'
          render json: { resultado_API: 'Item excluido com sucesso!' }
      else
        puts 'O item já foi enviado para a cozinha'
        render json: { resultado_API: 'Desculpe não conseguimos excluir este item porque ele já está sendo preparado.' }

      end
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
    Qrpoint.update(@desk_order.qrpoint_id, status: 'Aberta')
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
