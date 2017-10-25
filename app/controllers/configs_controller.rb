class ConfigsController < ApplicationController
    before_action :set_config, only: [:show, :edit, :update, :destroy]
    before_action :must_login

    # GET /configs
    # GET /configs.json
    def index
      @configs = Config.all
    end

    # GET /configs/1
    # GET /configs/1.json
    def show
    end

    # GET /configs/new
    def new
      @config = Config.new
    end

    # GET /configs/1/edit
    def edit
    end

    # POST /configs
    # POST /configs.json
    def create
      @config = Config.new(config_params)

      respond_to do |format|
        if @config.save
          format.html { }
          format.json { render :show, status: :created, location: @config }
          sweetalert_success('Configurações criadas com sucesso.', 'Aviso', useRejections: false)
          redirect_to @config
        else
          format.html { render :new }
          format.json { render json: @config.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /configs/1
    # PATCH/PUT /configs/1.json
    def update

      respond_to do |format|
        if @config.update(config_params)
          format.html { }
          format.json { render :show, status: :ok, location: @config }
          sweetalert_success('Configurações atualizadas com sucesso.', 'Aviso', useRejections: false)
          redirect_to @config
        else
          format.html { render :edit }
          format.json { render json: @config.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /configs/1
    # DELETE /configs/1.json
    def destroy
      @config.destroy
      #inserindo no log de atividades
          log = Loginfo.new(params[:loginfo])
          log.employee = current_user.name
          log.task = 'Excluiu configuração - Nome: ' + @config.razao.to_s
          log.save!
      redirect_to configs_url
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_config
        @config = Config.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def config_params
        params.require(:config).permit(:razao, :nome_fantasia, :cnpj, :cep, :endereco, :numero, :bairro, :cidade, :uf, :telefone, :inscricao, :check_date, :expiration_date ,:check_env, :ref,:url_server_test,:token_test,:url_server_production,:token_production,:port,:sleep,:email,:site)
      end
  end
