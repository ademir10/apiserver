class ApplicationController < ActionController::Base

  #alterei aqui para aceitar requisições do aplicativo
  protect_from_forgery unless: -> { request.format.json? }
  helper_method :current_user, :logged_in?

  def current_user
   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def must_login
    if !logged_in?

      sweetalert_error('Você ainda não esta logado, efetue o login.', 'Atenção!')
      redirect_to root_path
    end
  end


  #USADO PARA NÃO DEIXAR DAR O ERRO DE RELACIONAMENTO ENTRE TABELAS
  rescue_from 'ActiveRecord::InvalidForeignKey' do
  redirect_to message_error_relation_tables_path
  end
end
