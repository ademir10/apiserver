Rails.application.routes.draw do
  resources :configs
  resources :form_payments
  #Para o action cable
  mount ActionCable.server => '/cable'

  #ROTAS DO APLICATIVO
  #verifica se a mesa esta liberada
  post 'check_mesa', to: 'desk_orders#check_mesa'
  #lista as categorias dos produtos no cardápio
  get 'list_categories', to: 'desk_orders#list_categories'
  #lista os produtos de acordo com a categoria selecionada
  post 'list_products', to: 'desk_orders#list_products'
  #adiciona o produto selecionado na mesa que está aberta
  post 'add_product', to: 'desk_orders#add_product'
  #exibe tudo o que já foi consumido
  post 'check_order', to: 'desk_orders#check_order'
  #solicita o fechamento da mesa
  post 'close_order', to: 'desk_orders#close_order'
  #exclui o item selecionado se ainda não mudou o status
  post 'delete_item', to: 'desk_orders#delete_item'
  #----------------------------------------------------
  resources :payments
  resources :loginfos
  resources :suppliers do
  #para autocompletar o nome do produto
  get :autocomplete_supplier_name, :on => :collection
  end
  resources :receipts
  resources :qrpoints
  resources :items
  resources :desk_orders do
    member do
     post 'baixar'
     post 'nfce'
     get 'gerar_nfce'
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
