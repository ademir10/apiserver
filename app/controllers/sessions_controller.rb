class SessionsController < ApplicationController

  def expired_date
    #just to show expired view
  end

  def new

  end

  def create

    if params[:email].blank? || params[:password].blank?
      sweetalert_error('Informe os seus dados!', 'Atenção!')

         redirect_to root_path and return
    end

    user = User.find_by_email(params[:email])
    if user && user.password == (params[:password])
    session[:user_id] = user.id

    #inserindo no log de atividades
        #log = Loginfo.new(params[:loginfo])
        #log.employee = current_user.name
        #log.task = 'Efetuou o Login no sistema'
        #log.save!


    #se estiver tudo ok e a licença ok

  sweetalert_success('Bem vindo ' + current_user.name.to_s + "!", 'Olá!')
     redirect_to dashboard_path
   else

     sweetalert_warning('Dados inválidos, tente outra vez!', 'Erro.')
      redirect_to root_path
  end
end

  def destroy
     #inserindo no log de atividades
        #log = Loginfo.new(params[:loginfo])
        #log.employee = current_user.name
        #log.task = 'Efetuou o Logout no sistema'
        #log.save!

    session[:user_id] = nil
     sweetalert_success('See you soon!', '')

    redirect_to root_path
  end
end
