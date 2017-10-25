class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]
  before_action :show_form_payment, only: [:new, :show, :edit, :update, :destroy, :create]
  before_action :must_login

 def index
     if params[:date1].blank?
      params[:date1] = Date.today
     end
     if params[:date2].blank?
      params[:date2] = Date.today
     end

      if params[:date1].present? && params[:date2].present? && params[:tipo_consulta].blank?
        @receipts = Receipt.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).order(:id)
        @total_por_forma_recebimento = Receipt.select('form_payments.type_payment', 'sum(value_doc) as total').joins(:form_payment).where("receipts.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).group('form_payments.type_payment').order('form_payments.type_payment')
        @total_receipts = Receipt.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).sum(:value_doc)

      elsif params[:date1].present? && params[:date2].present? && params[:tipo_consulta].present?
        @receipts = Receipt.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).where(status: params[:tipo_consulta]).order(:id)
        @total_por_forma_recebimento = Receipt.select('form_payments.type_payment', 'sum(value_doc) as total').joins(:form_payment).where("receipts.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).where(status: params[:tipo_consulta]).group('form_payments.type_payment').order('form_payment.type_payment')
        @total_receipts = Receipt.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).where(status: params[:tipo_consulta]).sum(:value_doc)

       end
  end

  # GET /receipts/1
  # GET /receipts/1.json
  def show
  end

  # GET /receipts/new
  def new
    @receipt = Receipt.new
  end

  # GET /receipts/1/edit
  def edit
  end

  # POST /receipts
  # POST /receipts.json
  def create

    if receipt_params[:installments].blank?
       sweetalert_warning('Você precisa informar a quantidade de parcelas!', 'Atenção!', useRejections: false)
      redirect_to new_receipt_path and return
    end

    @receipt = Receipt.new(receipt_params)
    @qnt_parcela = receipt_params[:installments].to_i

    #se for somente uma parcela ele só salva uma vez
    if @qnt_parcela == 1

          if @receipt.save
            #inserindo no log de atividades
            log = Loginfo.new(params[:loginfo])
            log.employee = current_user.name
            log.task = 'Cadastrou nova conta á receber - Nº doc ' + receipt_params[:doc_number].to_s
            log.save!

              sweetalert_success('Dados cadastrados com sucesso!', 'Sucesso!', useRejections: false)
              redirect_to @receipt
            else
              format.html { render :new }
              format.json { render json: @receipt.errors, status: :unprocessable_entity }
            end
     else
          #se tiver mais de uma parcela ele lança a quantidade de vezes no sistema
          if @qnt_parcela > 1
            @valor_total = receipt_params[:value_doc].to_f
            @resultado = @valor_total / @qnt_parcela
            @resultado = (@resultado).round(2)
            @data_vencto = receipt_params[:due_date]
          end

              while @qnt_parcela > 0
                   @conta_parc = @conta_parc.to_i + 1
                   @data_vencto = @data_vencto.to_date + 1.month
                   @receipt.description = receipt_params[:description] + ' Parc. ' + @conta_parc.to_s
                   @receipt.due_date = @data_vencto
                   @receipt.value_doc = @resultado

                      if @receipt.save
                        #só vai fazer o redirect quando finalizar
                      else
                        format.html { render :new }
                        format.json { render json: @receipt.errors, status: :unprocessable_entity }
                      end
                   @qnt_parcela = @qnt_parcela - 1
                   @receipt = Receipt.new(receipt_params)
               end
        #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Efetuou parcelamento conta á receber - Nº doc ' + receipt_params[:doc_number].to_s
        log.save!

         redirect_to receipts_path
         sweetalert_success('Dados cadastrados com sucesso!', 'Sucesso!', useRejections: false)
     end
  end

  # PATCH/PUT /receipts/1
  # PATCH/PUT /receipts/1.json
  def update
        #verifica se foi informada a forma de pagamento na baixa
    if receipt_params[:receipt_date].present? && receipt_params[:form_receipt].blank?
      sweetalert_warning('Selecione uma forma de Recebimento!', 'Atenção!', useRejections: false)
      redirect_to edit_receipt_path(@receipt) and return
    end

    #se informou a data da baixa e não alterou para PAGA o status
    if receipt_params[:receipt_date].present? && receipt_params[:status] == 'Á RECEBER'
        sweetalert_warning('Altere o Status para RECEBIDA, já que você informou a data de recebimento!', 'Atenção!', useRejections: false)
      redirect_to edit_receipt_path(@receipt) and return
    end

    #se alterou para PAGA o status e não informou a data do pagamento
    if receipt_params[:status] == 'RECEBIDA' && receipt_params[:receipt_date].blank?
      sweetalert_warning('Informe a data de recebimento, já que você alterou o status para RECEBIDA!', 'Atenção!', useRejections: false)
      redirect_to edit_receipt_path(@receipt) and return
    end

    respond_to do |format|
      if @receipt.update(receipt_params)
        #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Atualizou conta á receber - ID: ' + @receipt.id.to_s +  ' Nº doc ' + @receipt.doc_number.to_s
        log.save!
        format.html { }
        format.json { render :show, status: :ok, location: @receipt }
        sweetalert_success('Dados atualizados com sucesso.', 'Sucesso!', useRejections: false)
        redirect_to @receipt
      else
        format.html { render :edit }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receipts/1
  # DELETE /receipts/1.json
  def destroy
    @receipt.destroy
    #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Excluiu conta á receber - ID: ' + @receipt.id.to_s +  ' Nº doc ' + @receipt.doc_number.to_s
        log.save!
         sweetalert_success('Dados excluidos com sucesso.', 'Sucesso!', useRejections: false)
      redirect_to receipts_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receipt
      @receipt = Receipt.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def receipt_params
      params.require(:receipt).permit(:doc_number, :type_doc, :description, :due_date, :receipt_date, :installments, :value_doc, :status, :form_receipt, :desk_order_id, :form_payment_id)
    end

    def show_form_payment
      @form_payments = FormPayment.order(:type_payment)
    end

end
