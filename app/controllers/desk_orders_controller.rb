class DeskOrdersController < ApplicationController
  before_action :set_desk_order, only: [:show, :edit, :update, :destroy, :baixar, :nfce]
  before_action :must_login, only: [:show, :edit, :update, :destroy]
  before_action :show_form_payment, only: [:show, :edit, :update, :destroy, :create, :baixar]
  before_action :show_pizzas, only: [:show]
  #Para permitir o acesso via aplicativo
  skip_before_action :verify_authenticity_token

  #para chamar o form modal e criar novo cliente
  def new_cliente
    @destinatario = Destinatario.new
    respond_to do |format|
      format.html
      format.js
    end

  end

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
          add_item.codigo_ncm = product.codigo_ncm
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
      form_payments = FormPayment.order(:type_payment)
      render json: { mesa_venda: desk_name.description, items_venda: items_desk_order , total_geral: sum_total_items, formas_pagamento: form_payments}
    end
  end

  #solicita o fechamento da mesa alterando somente o status da desk_order para "Solicita fechamento"
  def close_order
    if params["cardToken"].to_s == 'G0d1$@Bl3T0d0W4Th3V3Rth1Ng'
      DeskOrder.update(params[:desk_order_id], status: 'Solicita o fechamento', form_payment_id: params[:form_payment_selected].to_i)
      dados_qrpoint = DeskOrder.find(params[:desk_order_id])
      Qrpoint.update(dados_qrpoint.qrpoint_id, status: 'Solicita o fechamento' )
    end
  end

 #exclui o tem selecionado se ainda não foi enviado para a produção
 def delete_item
    item = Item.find(params[:item_id_app])
      if item.status != 'Em produção'
      item.destroy
        sum_items = Item.where(desk_order_id: params[:desk_order_id].to_i).sum(:val_total)
        DeskOrder.update(params[:desk_order_id].to_i, total: sum_items.to_f)
          render json: { resultado_API: 'Item excluido com sucesso!' }
      else

        render json: { resultado_API: 'Desculpe não conseguimos excluir este item porque ele já está sendo preparado.' }

      end
  end

  #chama a tela de cancelamento NFCe
  def cancelar_nfe
    @desk_order = DeskOrder.find(params[:id])
    @show_emitente = Config.first
  end

  #efetiva o cancelamento da NFCe
  def cancel_nfe

    if desk_order_params[:justificativa_cancelamento].blank?
                  sweetalert_warning("Você precisa informar uma justificativa!", 'Atenção', persistent: 'OK')
            redirect_to cancelar_nfe_path(:id => desk_order_params[:id]) and return
    end

    require 'net/http'
    require 'json'

    #para verificar em qual ambiente está a App
    @show_emitente = Config.first

      if @show_emitente.check_env == 'Teste'
        puts 'ambiente de TESTE e o SERVER é ' + @show_emitente.url_server_test.to_s + ' E TOKEN ' + @show_emitente.token_test.to_s
        server = @show_emitente.url_server_test.to_s;
        token = @show_emitente.token_test.to_s;
      else
        puts 'ambiente de PRODUÇÃO e o SERVER é ' + @show_emitente.url_server_production.to_s + ' E TOKEN ' + @show_emitente.token_production.to_s
        server = @show_emitente.url_server_production.to_s;
        token = @show_emitente.token_production.to_s;
      end
       # porta de comunicação
      port = @show_emitente.port.to_i

      ref = desk_order_params[:id].to_i
      @desk_order = DeskOrder.find(desk_order_params[:id])

      hash = {}
      hash[:justificativa] = desk_order_params[:justificativa_cancelamento].to_s

  Net::HTTP.start(server, port) do |http|

       url = "/nfce/#{ref}.json?token=#{token}&justificativa=#{URI.encode(hash[:justificativa])}"

       res = http.delete(url)
       codigo_sefaz = res.code.to_i

                if codigo_sefaz == 200

                       url = "/nfce/#{ref}.json?token=#{token}"
                       res = http.get(url)
                          response = JSON.parse(res.body)
                          codigo_sefaz = res.code.to_i

                          DeskOrder.update(@desk_order.id, status: 'NFCe cancelada', justificativa_cancelamento: desk_order_params[:justificativa_cancelamento], url_xml: 'https://api.focusnfe.com.br' + response['caminho_xml_nota_fiscal'], caminho_xml_cancelamento: 'https://api.focusnfe.com.br' + response['caminho_xml_cancelamento'])

                                      #inserindo no log de atividades
                                      log = Loginfo.new(params[:loginfo])
                                      log.employee = current_user.name
                                      log.task = 'Cancelamento de NFCe ref venda: ' + desk_order_params[:id].to_s
                                      log.save!

                         sweetalert_success("NFCe cancelada com sucesso!".force_encoding("UTF-8"), 'Aviso', persistent: 'OK')
                          redirect_to desk_orders_path and return

                 else

                       url = "/nfce/#{ref}.json?token=#{token}"
                       res2 = http.get(url)

                          response = JSON.parse(res2.body)
                          codigo_sefaz = res2.code.to_i

                                      #inserindo no log de atividades
                                      log = Loginfo.new(params[:loginfo])
                                      log.employee = current_user.name
                                      log.task = 'Tentativa de cancelamento de NFCe ref venda: ' + desk_order_params[:id].to_s
                                      log.save!
                          sweetalert_warning("Retorno Sefaz: " + "(" + "#{res2.code}" + ")" + " #{response['mensagem_sefaz_cancelamento']}".force_encoding("UTF-8"), 'Aviso', persistent: 'OK')
                          redirect_to desk_orders_path and return
                 end
        end
  end

  #gerando o cupom fiscal
  def nfce
    require 'net/http'
    require 'json'

      @desk_order.update(desk_order_params)

      #verifica se os campos obrigatórios foram preenchidos primeiro
        if desk_order_params[:forma_pagamento_nfce].blank?
          sweetalert_warning('Selecione uma forma de pagamento!', 'Atenção', persistent: 'OK')
          redirect_to gerar_nfce_desk_order_path() and return
        end

      #verifica se a forma de pagamento é Débito ou crédito, se for tem que informar a bandeira do cartão
      if desk_order_params[:forma_pagamento_nfce] == '03' && desk_order_params[:bandeira_operadora].blank?
        sweetalert_warning('Você precisa informar a bandeira do cartão!', 'Atenção', persistent: 'OK')
        redirect_to gerar_nfce_desk_order_path(desk_order_params) and return
      end

      if desk_order_params[:forma_pagamento_nfce] == '04' && desk_order_params[:bandeira_operadora].blank?
        sweetalert_warning('Você precisa informar a bandeira do cartão!', 'Atenção', persistent: 'OK')
        redirect_to gerar_nfce_desk_order_path(desk_order_params) and return
      end

  #para verificar em qual ambiente está a App
      @show_emitente = Config.first

        if @show_emitente.check_env == 'Teste'
          puts 'ambiente de TESTE e o SERVER é ' + @show_emitente.url_server_test.to_s + ' E TOKEN ' + @show_emitente.token_test.to_s
          server = @show_emitente.url_server_test.to_s;
          token = @show_emitente.token_test.to_s;
        else
          puts 'ambiente de PRODUÇÃO e o SERVER é ' + @show_emitente.url_server_production.to_s + ' E TOKEN ' + @show_emitente.token_production.to_s
          server = @show_emitente.url_server_production.to_s;
          token = @show_emitente.token_production.to_s;
        end

       #se estiver em ambiente de testes é obrigatória a informação do CPF / CNPJ
        if @show_emitente.check_env == 'Teste' && desk_order_params[:cpf_cnpj_nfce].blank?
          sweetalert_warning('No ambiente de testes é obrigatório informar um CPF / CNPJ válidos.', 'Atenção', persistent: 'OK')
        redirect_to gerar_nfce_desk_order_path(desk_order_params) and return
        end

         # porta de comunicação
        port = @show_emitente.port.to_i

       @desk_orders = DeskOrder.find(params[:id])


        #carregando os dados do cabeçalho da NFCe
        hash = {}

        #dados do emitente
        hash[:cnpj_emitente] = @show_emitente.cnpj
        hash[:nome_emitente] = @show_emitente.razao
        hash[:nome_fantasia_emitente] = @show_emitente.nome_fantasia
        hash[:logradouro_emitente] = @show_emitente.endereco
        hash[:numero_emitente] = @show_emitente.numero
        hash[:bairro_emitente] = @show_emitente.bairro
        hash[:municipio_emitente] = @show_emitente.cidade
        hash[:uf_emitente] = @show_emitente.uf
        hash[:cep_emitente] = @show_emitente.cep
        hash[:inscricao_estadual_emitente] = @show_emitente.inscricao

        hash[:data_emissao] = DateTime.now
        hash[:natureza_operacao] = 'Venda ao Consumidor'
        hash[:tipo_documento] = 1
        hash[:presenca_comprador] = 1
        hash[:finalidade_emissao] = 1
        hash[:modalidade_frete] = 9
        hash[:forma_pagamento] = 0

        #se for ambiente de testes
        if @show_emitente.check_env == 'Teste'
        hash[:nome_destinatario] = 'NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL'
                else
        hash[:nome_destinatario] = @desk_orders.destinatario.nome
        end

        if desk_order_params[:cpf_cnpj_nfce].blank?
          hash[:consumidor_final] = 1
        else
              if desk_order_params[:cpf_cnpj_nfce].mb_chars.length == 14
                hash[:cpf_destinatario] = desk_order_params[:cpf_cnpj_nfce]
              elsif desk_order_params[:cpf_cnpj_nfce].mb_chars.length > 14
                hash[:cnpj_destinatario] = desk_order_params[:cpf_cnpj_nfce]
              end
        end

        puts 'ESSE É O CPF ' + hash[:cpf_destinatario].to_s

        puts 'ESSE É O CNPJ ' + hash[:cnpj_destinatario].to_s

        if desk_order_params[:email_destinatario].present?
          #hash[:email_destinatario] = @desk_orders.email_nfce
        end
        hash[:informacoes_adicionais_contribuinte] = @desk_orders.informacoes_adicionais_contribuinte

        hash[:valor_produtos] = @desk_orders.total
        hash[:valor_desconto] = '0.00'
        hash[:valor_total] = @desk_orders.total

        #carregando os itens da NFCe
        hash[:items] = []
        counter = 0
        @desk_orders.items.order(:id).each do |i|
        i_hash = {}
        i_hash[:numero_item] = counter+=1
        i_hash[:codigo_produto] = i.product_id
        i_hash[:descricao] = i.product.name
        i_hash[:codigo_ncm] = i.product.codigo_ncm
        i_hash[:cfop] = i.cfop
        i_hash[:icms_origem] = 0
        i_hash[:icms_situacao_tributaria] = i.icms_situacao_tributaria
        i_hash[:unidade_comercial] = i.product.unidade_comercial
        i_hash[:unidade_tributavel] = i.product.unidade_comercial
        i_hash[:quantidade_comercial] = i.qnt
        i_hash[:quantidade_tributavel] = i.qnt
        i_hash[:valor_unitario_comercial] = i.val_unit
        i_hash[:valor_unitario_tributavel] = i.val_unit
        i_hash[:valor_bruto] = i.val_total
        hash[:items] << i_hash
        end

        hash[:formas_pagamento] = []
        @desk_orders.items.each do |f|
        f_hash = {}
        f_hash[:forma_pagamento] = @desk_orders.forma_pagamento_nfce
        f_hash[:valor_pagamento] = f.val_total
        #se a forma de pagamento for Débito ou crédito, precisa informar a bandeira do cartão
        if @desk_orders.forma_pagamento_nfce == '03' || @desk_orders.forma_pagamento_nfce == '04'
          puts 'TÁ PASSANDO AQUI SIM NA BANDEIRA!!!'
          f_hash[:bandeira_operadora] = @desk_orders.bandeira_operadora
        end

        hash[:formas_pagamento] << f_hash
       end


        puts "=> Teste de envio NFCe"

            # A referência é uma string que identifica univocamente uma NFSe e
            # será usada para consultas posteriores
            # tem que ser a mesma ref usada no envio
            ref = params[:id].to_i

        Net::HTTP.start(server, port) do |http|

          res = http.post("/nfce.json?ref=#{ref}&token=#{token}", hash.to_json)


          puts "Status = #{res.code}"
          puts "Body = #{res.body}"
          codigo_sefaz = res.code.to_i

          if Net::HTTPSuccess === res
            # Se a nota for aceita para processamento, o body vem vazio, deve-se agendar
            # em seguida uma consulta da nota
            puts "Nota aceita para processamento"

                   if codigo_sefaz == 201
                      response = JSON.parse(res.body)
                      sweetalert_warning(response['mensagem_sefaz'].to_s, 'Aviso', persistent: 'OK')
                        #gerando a URL da DANFE
                        if response['status'] == 'autorizado'
                          @desk_order = DeskOrder.find(params[:id])
                            DeskOrder.update(@desk_order.id, status: 'NFCe emitida Nº' + response['numero'], url_danfe: 'https://api.focusnfe.com.br' + response['caminho_danfe'], url_xml: 'https://api.focusnfe.com.br' + response['caminho_xml_nota_fiscal'])
                            sweetalert_success('NFCe Nº' + response['numero'].to_s + ' foi emitida com sucesso!', 'Aviso', persistent: 'OK')

                              #redireciona para o cupom fiscal
                              #@desk_order.update(desk_order_params)
                              #redirect_to print_cupom_path(id: @desk_order) and return

                        elsif response['status'] == 'processando_autorizacao'
                           sweetalert("Não houve tempo hábil para processar sua requisição, tente novamente: " + "(" + "#{res.code}" + ")" + " #{res.body}".force_encoding("UTF-8"), 'Aviso', persistent: 'OK')
                            redirect_to desk_order_path(@desk_order) and return
                        end
                    end

                   #se a nfe já foi emitida para garantir é salvo novamente o endereço do xml e danfe
                   elsif codigo_sefaz == 422
                    sweetalert("Ocorreu um erro: " + "(" + "#{res.code}" + ")" + " #{res.body}".force_encoding("UTF-8"), 'Aviso', persistent: 'OK')
                   end


            #inserindo no log de atividades
                log = Loginfo.new(params[:loginfo])
                log.employee = current_user.name
                log.task = 'Tentativa de emissão de NFCe ref venda: ' + params[:id].to_s
                log.save!

         end

       redirect_to desk_orders_path and return
       #render :json => hash
    end

  def gerar_nfce
    @desk_order = DeskOrder.find(params[:id])

    #verifica se já é uma venda, caso contrário não permite a emissão da NFE
    if @desk_order.status == 'NFCe emitida'
      sweetalert_warning('Você já emitiu uma nota fiscal do consumidor eletrônica para esta venda!', 'Atenção', useRejections: false)
       redirect_to desk_order_path(@desk_order) and return
    end

     #VERIFICA SE SE TODOS OS PRODUTOS ADICIONADOS NA VENDA JÁ FORAM INFORMADOS OS IMPOSTOS PARA LIBERAR O BOTÃO
          #DE EMISSÃO DA NOTA FISCAL
           Item.where(desk_order_id: @desk_order).find_each do |item|
             if item.cfop.blank? || item.cfop == '' || item.codigo_ncm.blank? || item.codigo_ncm == '' || item.icms_situacao_tributaria.blank? || item.icms_situacao_tributaria == ''
                 @check_tributos = @check_tributos.to_s + ' ' + item.product.name.to_s + ', '
                 end
           end
                   if @check_tributos.present?
                   sweetalert_warning('Você não informou o codigo NCM para o(s) produto(s): ' + @check_tributos, 'Atenção', persistent: 'OK')
                   redirect_to desk_order_path(@desk_order) and return
                   end

    @show_emitente = Config.first
    @total_items = Item.where(desk_order_id: @desk_order.id).sum(:val_total)
  end

  def baixar
    @config = Config.first
    @desk_order = DeskOrder.find(params[:id])

    #verifica se foi adicionado algum item na desk_order
    @qnt_items = Item.where(desk_order_id: @desk_order.id).count
    if @qnt_items == 0
       sweetalert_warning('Insira pelo menos 1 item!', 'Atenção!', useRejections: false)
     redirect_to desk_order_path(@desk_order) and return
    end

    #verifica se foi informada a forma de pagamento no caso de O.S
    if desk_order_params[:form_payment_id].blank?
       sweetalert_warning('Selecione uma forma de pagamento válida!', 'Atenção!', useRejections: false)
      redirect_to desk_order_path(@desk_order) and return
    end

     # SE JÁ FOI RECEBIDA A VENDA. não enviará para o contar á Receber
     if @desk_order.status == "Recebida"  || @desk_order.status == "Finalizada"
       @total_items = Item.where(desk_order_id: @desk_order.id).sum(:val_total)
      return

     else

           #FAZENDO A SOMA DE TODOS OS ITENS PARA JOGAR NO CONTAS Á RECEBER
           @total_items = Item.where(desk_order_id: @desk_order.id).sum(:val_total)

           #verifica se já foi enviado para o contas á receber
           if Receipt.exists?(desk_order_id: @desk_order.id)

           else

              #ENVIANDO PARA O CONTAS Á RECEBER
              cta_receber = Receipt.new(params[:receipt])
              cta_receber.doc_number = @desk_order.id
              cta_receber.type_doc = "Venda"
              if @desk_order.destinatario_id.blank?
              cta_receber.description = 'Referente Venda: ' + @desk_order.qrpoint.description.to_s
            else
              cta_receber.description = 'Ref Venda delivery Cliente: ' + @desk_order.destinatario.nome.to_s
            end
              cta_receber.value_doc = @total_items.round(2).to_f
              cta_receber.due_date = Date.today
              cta_receber.receipt_date = Date.today
              cta_receber.installments = 1
              cta_receber.status = "Recebida"
              cta_receber.desk_order_id = @desk_order.id
              cta_receber.form_payment_id = desk_order_params[:form_payment_id]
              cta_receber.save!
              #sweetalert_success('Mesa fechada!', 'Sucesso!')
            end

            if @desk_order.status == "Solicita o fechamento" || @desk_order.status == "Aberta" || @desk_order.status == "Em uso"

              log = Loginfo.new(params[:loginfo])
              log.employee = current_user.name
              log.task = 'Finalizou a mesa de nome: ' + @desk_order.qrpoint.description.to_s
              log.save!
              #finalizando a O.S e salvando a forma de pagamento
              DeskOrder.update(@desk_order.id, status: 'Finalizada', form_payment_id: desk_order_params[:form_payment_id], troco_para: desk_order_params[:troco_para], obs: desk_order_params[:obs])
              Qrpoint.update(@desk_order.qrpoint_id, status: 'Aberta')
              @desk_order = DeskOrder.find(params[:id])

            else
              log = Loginfo.new(params[:loginfo])
              log.employee = current_user.name
              log.task = 'Finalizou a venda do cliente: ' + @desk_order.destinatario.nome.to_s
              log.save!
              #finalizando a O.S e salvando a forma de pagamento
              DeskOrder.update(@desk_order.id, status: 'Finalizada', form_payment_id: desk_order_params[:form_payment_id], troco_para: desk_order_params[:troco_para], obs: desk_order_params[:obs])
              @desk_order = DeskOrder.find(params[:id])
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
    @desk_orders = DeskOrder.where("desk_orders.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).order('desk_orders.created_at')
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
    if @desk_order.destinatario_id.blank?
    Qrpoint.update(@desk_order.qrpoint_id, status: 'Aberta')
  end
    Receipt.where(desk_order_id: @desk_order).destroy_all

    #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        if @desk_order.destinatario_id.blank?
        log.task = 'Excluiu venda da mesa Nº: ' + @desk_order.qrpoint.description.to_s
        else
        log.task = 'Excluiu venda delivery cliente: ' + @desk_order.destinatario.nome.to_s
        end
        log.save!
        sweetalert_success('Venda excluida com sucesso!', 'Sucesso!', useRejections: false)
        redirect_to desk_orders_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_desk_order
      @desk_order = DeskOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def desk_order_params
      params.require(:desk_order).permit(:id, :number, :total, :status, :qrpoint_id, :type_service, :form_payment_id, :cpf_cnpj_nfce, :email_nfce, :forma_pagamento_nfce, :bandeira_operadora, :informacoes_adicionais_contribuinte, :environment, :url_danfe, :url_xml, :justificativa_cancelamento, :caminho_xml_cancelamento, :destinatario_id, :troco_para, :obs)
    end

    def show_form_payment
      @form_payments = FormPayment.order(:type_payment)
    end

    def show_pizzas
      @products = Product.joins(:category).where('categories.name = ?', 'Pizzas').order('products.name')
    end
end
