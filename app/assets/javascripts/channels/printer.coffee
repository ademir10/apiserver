App.printer = App.cable.subscriptions.create "PrinterChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (variavel_printer) ->

  speak: (variavel_printer)->
    @perform 'speak', message: variavel_printer
    #chama a impressão
    window.print()
