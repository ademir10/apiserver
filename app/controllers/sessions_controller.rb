class SessionsController < ApplicationController

  def expired_date
    sweetalert_warning('A sua licença expirou, efetue o pagamento e entre em contato com o suporte para reativa-la.!', 'Atenção!', useRejections: false)
    redirect_to root_path and return
  end

  def new

  end

  def create
    if params[:email].blank? || params[:password].blank?
      sweetalert_error('Informe os seus dados!', 'Atenção!', useRejections: false)
      redirect_to root_path and return
    end

    user = User.find_by_email(params[:email])
    if user && user.password == (params[:password])
    session[:user_id] = user.id

    #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Efetuou o Login no sistema'
        log.save!
puts 'AQUI É A DATA DE AMANHÃ ' + Date.tomorrow.to_s
  if current_user.type_access != 'MASTER'
      #verifica se a licença de uso está ok somente se o usuario não for MASTER
      check_date = Config.first

  if check_date.check_date == '1' && check_date.expiration_date.to_date == Date.today.to_date
    #faltando 1 dia para vencer a licença o cliente é alertado
    sweetalert("Olá" + " " +  user.name + "!", 'Hoje, dia ' + Date.today.to_s + ' vence a sua licença, a partir de amanhã o sistema será bloqueado automaticamente, efetue o pagamento e entre em contato com o departamento financeiro para reativa-lo.', imageUrl: 'images/logo.png', persistent: 'OK')
    redirect_to root_path and return

  elsif check_date.check_date == '1' && Date.tomorrow.to_date == check_date.expiration_date.to_date
    #faltando 1 dia para vencer a licença o cliente é alertado
    sweetalert("Olá" + " " +  user.name + "!", 'Gostariamos de lembrar que amanhã ' + Date.tomorrow.to_s + ' vence a sua licença, não se esqueça de renova-la pois o sistema será bloqueado automaticamente após esta data.', imageUrl: 'images/logo.png', persistent: 'OK')
    redirect_to root_path and return

  elsif check_date.check_date == '1' && check_date.expiration_date.to_date < Date.today.to_date
      #para informar ao form que expirou e precisa mostrar os dados bancários para pagamento
      params[:expire_date] = check_date.expiration_date

       sweetalert_error('A sua licença expirou, efetue o pagamento e informe o departamento financeiro para que seja feito o desbloqueio automático.', 'Atenção' , persistent: 'OK')
      session[:user_id] = nil
     redirect_to root_path and return
      end
     end
    #se estiver tudo ok e a licença ok
    sweetalert("Oi" + " " +  user.name + "!", 'Bem vindo!', imageUrl: 'images/logo.png')
    redirect_to root_path

    else
      sweetalert_error('Email ou Senha incorretos, por favor verifique os dados.', 'Atenção')
      redirect_to root_path
      #render 'new'
    end
  end

  def destroy
     #inserindo no log de atividades
        #log = Loginfo.new(params[:loginfo])
        #log.employee = current_user.name
        #log.task = 'Efetuou o Logout no sistema'
        #log.save!

    session[:user_id] = nil
     sweetalert_success('See you soon!', '', useRejections: false)

    redirect_to root_path
  end
end
