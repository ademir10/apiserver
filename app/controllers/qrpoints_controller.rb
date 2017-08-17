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
      if @qrpoint.save
        format.html { redirect_to @qrpoint, notice: 'Qrpoint was successfully created.' }
        format.json { render :show, status: :created, location: @qrpoint }
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
        format.html { redirect_to @qrpoint, notice: 'Qrpoint was successfully updated.' }
        format.json { render :show, status: :ok, location: @qrpoint }
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
    respond_to do |format|
      format.html { redirect_to qrpoints_url, notice: 'Qrpoint was successfully destroyed.' }
      format.json { head :no_content }
    end
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
