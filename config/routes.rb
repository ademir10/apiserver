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

  #abrindo um form modal para informar os tributos do pruduto na invoice
  get 'items/editar_tributo' => 'items#editar_tributo', :as => :editar_tributo

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

  resources :items

  #para cancelar a nfe
  get 'cancelar_nfe', to: 'desk_orders#cancelar_nfe'
  #para efetivar o cancelamento da nfe
  post 'cancel_nfe', to: 'desk_orders#cancel_nfe'

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
  #para carregar a view informando que não pode excluir cadastro com relacionamento em outra table
  get 'message_error_relation_tables', to: 'pages#message_error_relation_tables'
end
