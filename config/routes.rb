Rails.application.routes.draw do

  #ROTAS DO APLICATIVO
  #verifica se a mesa esta liberada
  post 'check_mesa', to: 'desk_orders#check_mesa'
  #lista as categorias dos produtos no cardápio
  get 'list_categories', to: 'desk_orders#list_categories'
  #lista os produtos de acordo com a categoria selecionada
  post 'list_products', to: 'desk_orders#list_products'
  #----------------------------------------------------


  resources :qrpoints
  resources :items
  resources :desk_orders do
    member do
     post 'baixar'
   end
    resources :items do

    end
  end
  resources :products do
    #para autocompletar o nome do produto
   get :autocomplete_product_name, :on => :collection
  end
  #rota para consultar produto selecionado no combobox na Ordem de serviço
  get 'consulta_prod', to: 'products#consulta_prod'

  resources :categories
  get 'pages/login'

  resources :users
  root 'pages#login'

  get 'sessions/new'
  #rotas para o login
  get 'expired', to: 'sessions#expired_date'
  get 'pages/index'
  get 'login', to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'
  post 'login', to: 'sessions#create'
  #---------------------------------------------
  get 'dashboard', to: 'pages#dashboard'

end
