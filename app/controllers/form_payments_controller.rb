class FormPaymentsController < ApplicationController
  before_action :set_form_payment, only: [:show, :edit, :update, :destroy]

  # GET /form_payments
  # GET /form_payments.json
  def index
    @form_payments = FormPayment.all
  end

  # GET /form_payments/1
  # GET /form_payments/1.json
  def show
  end

  # GET /form_payments/new
  def new
    @form_payment = FormPayment.new
  end

  # GET /form_payments/1/edit
  def edit
  end

  # POST /form_payments
  # POST /form_payments.json
  def create
    @form_payment = FormPayment.new(form_payment_params)

    respond_to do |format|
      if @form_payment.save
        format.html { redirect_to @form_payment, notice: 'Form payment was successfully created.' }
        format.json { render :show, status: :created, location: @form_payment }
      else
        format.html { render :new }
        format.json { render json: @form_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /form_payments/1
  # PATCH/PUT /form_payments/1.json
  def update
    respond_to do |format|
      if @form_payment.update(form_payment_params)
        format.html { redirect_to @form_payment, notice: 'Form payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @form_payment }
      else
        format.html { render :edit }
        format.json { render json: @form_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /form_payments/1
  # DELETE /form_payments/1.json
  def destroy
    @form_payment.destroy
    respond_to do |format|
      format.html { redirect_to form_payments_url, notice: 'Form payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form_payment
      @form_payment = FormPayment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def form_payment_params
      params.require(:form_payment).permit(:type_payment)
    end
end
