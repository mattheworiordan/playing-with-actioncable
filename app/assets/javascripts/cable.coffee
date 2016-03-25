# Action Cable provides the framework to deal with WebSockets in Rails.
# You can generate new channels where WebSocket features live using the rails generate channel command.
#
# Turn on the cable connection by removing the comments after the require statements (and ensure it's also on in config/routes.rb).
#
#= require action_cable
#= require_self
#= require_tree ./channels

@App ||= {}

protocol = if location.protocol.match(/^https/)
  'wss'
else
  'ws'

App.cable = ActionCable.createConsumer("#{protocol}:#{location.host}/cable")

channel = App.cable.subscriptions.create "EventsChannel",
  connected: ->
    $('.connecting').hide()
    $('.connected').show()

  disconnected: ->
    $('.connecting').show().text('Oops, cable gone away, trying to reconnect')
    $('.connected').hide()

  received: (data) ->
    $('#connected-count').text(data.count)
