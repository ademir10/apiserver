class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]
  before_action :must_login
  #para autocompletar o nome do fornecedor
  autocomplete :supplier, :name, :full => true
  # GET /suppliers
  # GET /suppliers.json
  def index
    @suppliers = Supplier.order(:name)
  end

  # GET /suppliers/1
  # GET /suppliers/1.json
  def show
  end

  # GET /suppliers/new
  def new
    @supplier = Supplier.new
  end

  # GET /suppliers/1/edit
  def edit
  end

  # POST /suppliers
  # POST /suppliers.json
  def create
    @supplier = Supplier.new(supplier_params)

      if @supplier.save
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Cadastrou Fornecedor - Nome: ' + @supplier.name.to_s
        log.save!
        sweetalert_success('Dados cadastrados com sucesso!', 'Sucesso!')
        redirect_to @supplier
      else
        format.html { render :new }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
  end

  # PATCH/PUT /suppliers/1
  # PATCH/PUT /suppliers/1.json
  def update
      if @supplier.update(supplier_params)
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Atualizou Fornecedor - Nome: ' + @supplier.name.to_s
        log.save!
        sweetalert_success('Dados atualizados com sucesso!', 'Sucesso!')
        redirect_to @supplier
        else
        format.html { render :edit }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.json
  def destroy
    @supplier.destroy
    log = Loginfo.new(params[:loginfo])
    log.employee = current_user.name
    log.task = 'Excluiu Fornecedor - Nome: ' + @supplier.name.to_s
    log.save!
    redirect_to suppliers_url
    sweetalert_success('Dados excluidos com sucesso!', 'Sucesso!')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_params
      params.require(:supplier).permit(:name, :cep, :address, :neighborhood, :city, :state, :phone, :cellphone, :cnpj, :email)
    end
end
