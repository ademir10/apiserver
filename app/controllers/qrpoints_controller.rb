class QrpointsController < ApplicationController
  before_action :set_qrpoint, only: [:show, :edit, :update, :destroy]
  # GET /qrpoints
  # GET /qrpoints.json
  def index
    @qrpoints = Qrpoint.order(:description)
  end

  # GET /qrpoints/1
  # GET /qrpoints/1.json
  def show
    require 'google-qr'
    @codigo = @qrpoint.qrcode.to_s

    #gera o QRcode com o conteúdo inserido campo data:
    @QRcode = GoogleQR.new(:data => @codigo, :size => "80x80", :margin => 0, :error_correction => "L")
    @QRcodePrint = GoogleQR.new(:data => @codigo, :size => "300x300", :margin => 0, :error_correction => "L")
  end

  # GET /qrpoints/new
  def new
    @qrpoint = Qrpoint.new
  end

  # GET /qrpoints/1/edit
  def edit
  end

  # POST /qrpoints
  # POST /qrpoints.json
  def create
    @qrpoint = Qrpoint.new(qrpoint_params)
    respond_to do |format|
    @qrpoint.status = 'Aberta'
    if @qrpoint.save
      log = Loginfo.new(params[:loginfo])
      log.employee = current_user.name
      log.task = 'Cadastrou QRpoint - Nome: ' + @qrpoint.description.to_s
      log.save!
      format.html { }
      format.json { render :show, status: :created, location: @banco }
      redirect_to @qrpoint
      sweetalert_success('Dados cadastrados com sucesso!', 'Sucesso!', useRejections: false)
      else
        format.html { render :new }
        format.json { render json: @qrpoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /qrpoints/1
  # PATCH/PUT /qrpoints/1.json
  def update
    respond_to do |format|
    if @qrpoint.update(qrpoint_params)
      log = Loginfo.new(params[:loginfo])
      log.employee = current_user.name
      log.task = 'Atualizou QRpoint - Nome: ' + @qrpoint.description.to_s
      log.save!
      format.html { }
      format.json { render :show, status: :created, location: @qrpoint }
      sweetalert_success('Dados atualizados com sucesso!', 'Sucesso!', useRejections: false)
      redirect_to @qrpoint
    else
        format.html { render :edit }
        format.json { render json: @qrpoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /qrpoints/1
  # DELETE /qrpoints/1.json
  def destroy
    @qrpoint.destroy
    log = Loginfo.new(params[:loginfo])
    log.employee = current_user.name
    log.task = 'Excluiu QRpoint - Nome: ' + @qrpoint.description.to_s
    log.save!
    redirect_to qrpoints_url
    sweetalert_success('Dados excluidos com sucesso!', 'Sucesso!', useRejections: false)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_qrpoint
      @qrpoint = Qrpoint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def qrpoint_params
      params.require(:qrpoint).permit(:description, :qrcode, :status)
    end
end
