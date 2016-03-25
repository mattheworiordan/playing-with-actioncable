"use strict"

const Cable = require('es6-actioncable')
const Async = require('async')
const EventEmitter = require('events').EventEmitter

class Websocket {
  connect() {
    console.log('connecting websocket')
    this.consumer = Cable.createConsumer('ws://localhost:3000/cable/', { origin: 'http://localhost:3000' })
  }

  getConsumer() {
    if(!this.consumer) {
      this.connect()
    }
    return this.consumer
  }

  closeConnection() {
    if(this.consumer) {
      Cable.endConsumer(this.consumer)
    }
    delete this.consumer
  }
}

const clients = []
class EventsChannel extends EventEmitter {
  constructor() {
    super()
  }

  subscribe() {
    var _this = this
    this.subscription = (new Websocket).getConsumer().subscriptions.create("EventsChannel", {
      connected: function () {
        clients.push(this)
        _this.emit('connected')
      },
      disconnected: function () {
        clients.splice(clients.indexOf(this), 1)
        _this.emit('disconnected')
      },
      received: function (data) {
        _this.emit('count', data.count, data.broadcastAt)
      }
    })
  }

  unsubscribe() {
    if(this.subscription)
      this.subscription.unsubscribe()
  }
}

var startTime = new Date().getTime()

Async.timesLimit(2500, 50, function(n, next) {
  const channel = new EventsChannel()
  channel.subscribe()
  channel.on('connected', () => {
    console.log('Client', n, 'connected')
    channel.removeAllListeners('connected')
    channel.on('disconnected', () => {
      console.log('Client', n, 'disconnected')
    })
    next()
  })
  channel.on('count', (count, broadcastAt) => {
    console.log(clients.length, 'clients connected,' + count + ' reported by ActionCable. Elapsed time', Math.round(new Date().getTime() - broadcastAt), 'ms')
  })
}, function() {
  console.log('All clients connected in ', new Date().getTime() - startTime, 'ms')
})
