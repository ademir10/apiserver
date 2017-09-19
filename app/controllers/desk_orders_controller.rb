class DeskOrdersController < ApplicationController
  before_action :set_desk_order, only: [:show, :edit, :update, :destroy]
  before_action :must_login, only: [:show, :edit, :update, :destroy]
  before_action :show_form_payment, only: [:show, :edit, :update, :destroy, :create]
  #Para permitir o acesso via aplicativo
  skip_before_action :verify_authenticity_token

  # RECEBE O QRCODE DO APLICATIVO E VERIFICA SE A MESA ESTÁ DISPONÍVEL
  def check_mesa
      #verifica se o token é valido primeiro
      if params["cardToken"].to_s == 'G0d1$@Bl3T0d0W4Th3V3Rth1Ng'
         @verifica_mesa = Qrpoint.where(qrcode: params["numero_da_mesa"]).first
          if @verifica_mesa.present?
            #se a mesa está aberta, pode ser usada pelo cliente e pelo garçon
                  if @verifica_mesa.status == 'Aberta'
                      #altera o status da mesa para EM USO e inicia uma venda guardando o id da venda
                      desk_order = DeskOrder.new(params[:desk_order])
                      desk_order.status = 'Em uso'
                      desk_order.qrpoint_id = @verifica_mesa.id
                      desk_order.type_service = params[:tipo_atendimento]
                      desk_order.save!
                      render json: { retorno_rails: "A MESA ESTÁ LIVRE", id_da_mesa: desk_order.id }
                      #após a mesa aberta o status do QRpoint é mudado para Em USO
                      Qrpoint.update(@verifica_mesa.id, status: 'Em uso')
                  #se a mesa está em uso somente o garçon consegue adicionar itens
                   elsif @verifica_mesa.status == 'Em uso'
                     desk_order_opened = DeskOrder.where(status: 'Em uso').where(qrpoint_id: @verifica_mesa.id).first
                      id_order_aberta = desk_order_opened.id
                      render json: { retorno_rails: "A MESA ESTÁ EM USO", id_da_mesa: id_order_aberta, nome_qrpoint: @verifica_mesa.description  }
                    elsif @verifica_mesa.status == 'Solicita o fechamento'
                      render json: { retorno_rails: "AGUARDANDO O FECHAMENTO" }
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
         qrpoint = Qrpoint.find_by(qrcode: params[:qrpoint_name])
         #fazendo o calculo do total multiplicando a quantidade do mesmo item
         val_total_items = params[:qnt_product].to_i * product.value.to_f

          add_item = Item.new(params[:item])
          add_item.desk_order_id = params[:desk_order_id]
          add_item.product_id = params[:product_id]
          add_item.name_prod = product.name
          add_item.qnt = params[:qnt_product]
          add_item.val_unit = product.value
          add_item.val_total = val_total_items
          add_item.qrpoint_name = qrpoint.description
          add_item.local_print = product.local_print
          add_item.save!
          sum_items = Item.where(desk_order_id: params[:desk_order_id].to_i).sum(:val_total)
          DeskOrder.update(params[:desk_order_id].to_i, total: sum_items.to_f)
          render json: { produto_adicionado: product}
      end
  end

  #carrega tudo o que já foi consumido
  def check_order
    if params["cardToken"].to_s == 'G0d1$@Bl3T0d0W4Th3V3Rth1Ng'
      puts 'AQUI É O QUE TÁ CHEGANDO >>>>>>> ' + params[:desk_order_id].to_s
      qrpoint_number = DeskOrder.find(params[:desk_order_id])
      desk_name = Qrpoint.find(qrpoint_number.qrpoint_id)
      items_desk_order = Item.where(desk_order_id: params[:desk_order_id].to_i)
      sum_total_items = Item.where(desk_order_id: params[:desk_order_id].to_i).sum(:val_total)
      form_payments = FormPayment.order(:type_payment)
      render json: { mesa_venda: desk_name.description, items_venda: items_desk_order , total_geral: sum_total_items, formas_pagamento: form_payments}
      puts 'tudo certo até aqui obrigado Deus!'
    end
  end

  #solicita o fechamento da mesa alterando somente o status da desk_order para "Solicita fechamento"
  def close_order
    if params["cardToken"].to_s == 'G0d1$@Bl3T0d0W4Th3V3Rth1Ng'
      DeskOrder.update(params[:desk_order_id], status: 'Solicita o fechamento', form_payment_id: params[:form_payment_selected].to_i)
      dados_qrpoint = DeskOrder.find(params[:desk_order_id])
      Qrpoint.update(dados_qrpoint.qrpoint_id, status: 'Solicita o fechamento' )
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

  def baixar
    @desk_order = DeskOrder.find(params[:id])

    #verifica se foi adicionado algum item na Invoice
    @qnt_items = Item.where(desk_order_id: @desk_order.id).count
    if @qnt_items == 0
       sweetalert_warning('Insira pelo menos 1 item!', 'Atenção!')
     redirect_to desk_order_path(@desk_order) and return
    end

    #verifica se foi informada a forma de pagamento no caso de O.S
    if desk_order_params[:form_payment_id].blank?
       sweetalert_warning('Selecione uma forma de pagamento válida!', 'Atenção!')
      redirect_to desk_order_path(@desk_order) and return
    end

     # SE JÁ FOI RECEBIDA A VENDA. não enviará para o contar á Receber
     if @desk_order.status == "Recebida"  || @desk_order.status == "Finalizada"
      redirect_to print_cupom_path

     else

         if @desk_order.status == "Solicita o fechamento" || @desk_order.status == "Aberta" || @desk_order.status == "Em uso"
           #finalizando a O.S e salvando a forma de pagamento
           DeskOrder.update(@desk_order.id, status: 'Finalizada', form_payment_id: desk_order_params[:form_payment_id])
           Qrpoint.update(@desk_order.qrpoint_id, status: 'Aberta')

           log = Loginfo.new(params[:loginfo])
           log.employee = current_user.name
           log.task = 'Finalizou a mesa de nome: ' + @desk_order.qrpoint.description.to_s
           log.save!
         end

           #FAZENDO A SOMA DE TODOS OS ITENS PARA JOGAR NO CONTAS Á RECEBER
           @total_items = Item.where(desk_order_id: @desk_order.id).sum(:val_total)

           #verifica se já foi enviado para o contas á receber
           if Receipt.exists?(desk_order_id: @desk_order.id)

           else

              #ENVIANDO PARA O CONTAS Á RECEBER
              cta_receber = Receipt.new(params[:receipt])
              cta_receber.doc_number = @desk_order.id
              cta_receber.type_doc = "Venda"
              cta_receber.description = 'Referente Venda: ' + @desk_order.qrpoint.description.to_s
              cta_receber.value_doc = @total_items.round(2).to_f
              cta_receber.due_date = Date.today
              cta_receber.receipt_date = Date.today
              cta_receber.installments = 1
              cta_receber.status = "Recebida"
              cta_receber.desk_order_id = @desk_order.id
              cta_receber.form_payment_id = desk_order_params[:form_payment_id]
              cta_receber.save!
              sweetalert_success('Mesa fechada!', 'Sucesso!')

            end

        end
      end

  def index
    if params[:date1].blank?
     params[:date1] = Date.today
    end
    if params[:date2].blank?
     params[:date2] = Date.today
    end
    @desk_orders = DeskOrder.joins(:form_payment).where("desk_orders.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).order('desk_orders.created_at')
    @total_por_forma_pagamento = DeskOrder.select('form_payments.type_payment', 'sum(total) as total').joins(:form_payment).where("desk_orders.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).group('form_payments.type_payment').order('form_payments.type_payment')
    @total_desk_orders = DeskOrder.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).sum(:total)

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
    puts 'esse é o id da venda ' + @desk_order.id.to_s
    Receipt.where(desk_order_id: @desk_order).destroy_all

    #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Excluiu venda da mesa Nº: ' + @desk_order.qrpoint.description.to_s
        log.save!
        sweetalert_success('Venda excluida com sucesso!', 'Sucesso!')
        redirect_to desk_orders_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_desk_order
      @desk_order = DeskOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def desk_order_params
      params.require(:desk_order).permit(:id, :number, :total, :status, :qrpoint_id, :type_service, :form_payment_id)
    end

    def show_form_payment
      @form_payments = FormPayment.order(:type_payment)
    end
end
