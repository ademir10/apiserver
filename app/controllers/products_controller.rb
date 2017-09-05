class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :show_categories
  #para autocompletar o nome do produto
  autocomplete :product, :name

  #consultando e carregando os dados do produto selecionado que será adicionado na venda
  def consulta_prod
    @product = Product.select('id,name,qnt,value').where(id: params[:name]).first
    respond_to do |format|
    format.html
    format.json { render :json => @product }
    end
    #------------DEU CERTO GLORIA Á DEUS!!!-----------------------------------------------
  end

  def index
    @products = Product.order('category_id').order(:name)
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
      if product_params[:check_stock].blank? || product_params[:qnt].blank?
        @product.qnt = 0
      end

      if @product.save
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Cadastrou produto - Nome: ' + @product.name.to_s
        log.save!
        sweetalert_success('Dados cadastrados com sucesso!', 'Sucesso!')
        redirect_to @product
        else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
      if @product.update(product_params)
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Alterou produto - Nome: ' + @product.name.to_s
        log.save!
        redirect_to @product
        sweetalert_success('Dados atualizados com sucesso!', 'Sucesso!')
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    log = Loginfo.new(params[:loginfo])
    log.employee = current_user.name
    log.task = 'Excluiu produto - Nome: ' + @product.name.to_s
    log.save!

   sweetalert_success('Dados excluidos com sucesso!', 'Sucesso!')
  redirect_to products_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :qnt, :value, :category_id, :image, :remove_image, :description, :check_stock)
    end

    def show_categories
      @categories = Category.order('name')
    end
end
