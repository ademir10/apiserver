class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  before_action :show_supplier_name, only: [:new, :edit, :update, :create, :index, :report_payment]
  before_action :must_login

  def index
@payments = Payment.includes(:supplier).where(due_date: Date.today).order(:due_date)
    @total_payments = Payment.where(due_date: Date.today).sum(:value_doc)

    if params[:date1].present? && params[:date2].present? && params[:tipo_consulta].blank? && params[:fornecedor].blank?
       @payments = Payment.where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).order(:due_date)
       @total_payments = Payment.where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).sum(:value_doc)

     elsif params[:date1].present? && params[:date2].present? && params[:tipo_consulta].blank? && params[:fornecedor].present?
       @payments = Payment.where(supplier_id: params[:fornecedor]).where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).order(:due_date)
       @total_payments = Payment.where(supplier_id: params[:fornecedor]).where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).sum(:value_doc)



    elsif params[:date1].present? && params[:date2].present? && params[:tipo_consulta].present? && params[:fornecedor].blank?
       @payments = Payment.where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(status: params[:tipo_consulta]).order(:due_date)
       @total_payments = Payment.where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(status: params[:tipo_consulta]).sum(:value_doc)

    elsif params[:date1].present? && params[:date2].present? && params[:tipo_consulta].present? && params[:fornecedor].present?
       @payments = Payment.where("payment_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(supplier_id: params[:fornecedor]).where(status: params[:tipo_consulta]).order(:due_date)
       @total_payments = Payment.where("payment_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(supplier_id: params[:fornecedor]).where(status: params[:tipo_consulta]).sum(:value_doc)
    end
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)
    @qnt_parcela = payment_params[:installments].to_i

    if payment_params[:type_doc].blank? || payment_params[:supplier_id].blank? || payment_params[:description].blank? || payment_params[:due_date].blank? || payment_params[:installments].blank? || payment_params[:value_doc].blank?
        sweetalert_warning('Os dados precisam ser informados primeiro!', 'Atenção!')
      redirect_to new_payment_path and return
    end

    #verifica se foi informada a forma de pagamento na baixa
    if payment_params[:status] == 'Paga' && payment_params[:form_payment].blank?
        sweetalert_warning('Selecione uma forma de pagamento!', 'Atenção!')
      redirect_to new_payment_path and return
    end

    #se informou a data da baixa e não alterou para PAGA o status
    if payment_params[:payment_date].present? && payment_params[:status] == 'Á Pagar'
    sweetalert_warning('Altere o Status para PAGA, já que você informou a data de pagamento!', 'Atenção!')
      redirect_to new_payment_path and return
    end

    #se alterou para PAGA o status e não informou a data do pagamento
    if payment_params[:status] == 'Paga' && payment_params[:payment_date].blank?
        sweetalert_warning('Informe a data de pagamento, já que você alterou o status para PAGA!', 'Atenção!')
      redirect_to new_payment_path and return
    end


    #se for somente uma parcela ele só salva uma vez
    if @qnt_parcela == 1

            respond_to do |format|
              if @payment.save
        #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Cadastrou nova conta á pagar - Nº doc: ' + payment_params[:doc_number].to_s
        log.save!
                format.html { }
                format.json { render :show, status: :created, location: @payment }
                sweetalert_success('Pagamento cadastrado com sucesso!', 'Sucesso!')
                redirect_to @payment
              else
                format.html { render :new }
                format.json { render json: @payment.errors, status: :unprocessable_entity }
              end
            end
     else
          #se tiver mais de uma parcela ele lança a quantidade de vezes no sistema
          if @qnt_parcela > 1
            @valor_total = payment_params[:value_doc].to_f
            @resultado = @valor_total / @qnt_parcela
            @resultado = (@resultado).round(2)
            @data_vencto = payment_params[:due_date]
          end

        while @qnt_parcela > 0
         @conta_parc = @conta_parc.to_i + 1
         @data_vencto = @data_vencto.to_date + 1.month
         @payment.description = payment_params[:description] + ' Parc. ' + @conta_parc.to_s
         @payment.due_date = @data_vencto
         @payment.payment_date = Date.today
         @payment.value_doc = @resultado

            if @payment.save
              #só vai fazer o redirect quando finalizar
            else
              format.html { render :new }
              format.json { render json: @payment.errors, status: :unprocessable_entity }
            end
         @qnt_parcela = @qnt_parcela - 1
         @payment = Payment.new(payment_params)
        end
      redirect_to payments_path
      sweetalert_success('Parcelamento realizado com sucesso!', 'Sucesso!')
     end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    #verifica se foi informada a forma de pagamento na baixa
    if payment_params[:payment_date].present? && payment_params[:form_payment].blank?
        sweetalert_warning('Selecione uma forma de Pagamento!', 'Atenção!')
      redirect_to edit_payment_path(@payment) and return
    end

    #se informou a data da baixa e não alterou para PAGA o status
    if payment_params[:payment_date].present? && payment_params[:status] == 'Á Pagar'
        sweetalert_warning('Altere o Status para PAGA, já que você informou a data de pagamento!', 'Atenção!')
      redirect_to edit_payment_path(@payment) and return
    end

    #se alterou para PAGA o status e não informou a data do pagamento
    if payment_params[:status] == 'Paga' && payment_params[:payment_date].blank?
        sweetalert_warning('Informe a data de pagamento, já que você alerou o status para PAGA!', 'Atenção!')
      redirect_to edit_payment_path(@payment) and return
    end

    respond_to do |format|
      if @payment.update(payment_params)
        #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Atualizou conta á pagar - Nº doc ' + payment_params[:doc_number].to_s
        log.save!
        format.html { }
        format.json { render :show, status: :ok, location: @payment }
          sweetalert_success('Dados atualizados com sucesso.', 'Sucesso!')
        redirect_to @payment
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Excluiu conta á pagar - Nº doc ' + @payment.doc_number.to_s
        log.save!
        sweetalert_success('Dados excluidos com sucesso.', 'Sucesso!')
      redirect_to payments_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:doc_number, :description, :due_date, :payment_date, :installments, :value_doc, :type_doc, :form_payment, :status, :supplier_id,:purchase_id)
    end
    #mostra o nome do fornecedor
    def show_supplier_name
      @suppliers = Supplier.order(:name)
    end
end
