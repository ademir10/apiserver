App.desk_order = App.cable.subscriptions.create "DeskOrderChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (variavel_dados) ->
    # Called when there's incoming data on the websocket for this channel
    #swal("Aviso", variavel_dados['message'] + variavel_dados['teste'], "info");

    swal({title: 'Aviso!', text: variavel_dados['message'],timer: 5000, showCancelButton: false, showConfirmButton: false }).then();

  speak: (variavel_dados)->
    @perform 'speak', message: variavel_dados
