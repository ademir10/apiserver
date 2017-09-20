App.desk_order = App.cable.subscriptions.create "DeskOrderChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (variavel_dados) ->

    swal({title: 'Aviso!', text: variavel_dados['message'],timer: 5000, showCancelButton: false, showConfirmButton: false }).catch(swal.noop);

  speak: (variavel_dados)->
    @perform 'speak', message: variavel_dados
