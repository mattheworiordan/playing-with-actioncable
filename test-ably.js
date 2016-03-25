"use strict";

const ApiKey = '[INSERT-API-KEY-HERE]'

const Async = require('async')
const Ably = require('ably')
const Prompt = require('prompt')

var startTime = new Date().getTime()

function getChannel() {
  const client = new Ably.Realtime({ key: ApiKey, transports: ['web_socket'], log: { level: 2 } })
  return client.channels.get('events')
}

const publishChannel = getChannel()
Prompt.start()

function promptForPublish() {
  Prompt.get({ description: "Publish an event to all subscribers? [yes]" }, function(err, result) {
    if (err) {
      console.error("Error", err)
      process.exit();
    } else {
      if (result.question.toLowerCase() === 'yes') {
        console.log('Publishing count', clients.length)
        publishChannel.publish('count', { count: clients.length, broadcastAt: new Date().getTime() }, function() {
          setTimeout(promptForPublish, 1000);
        })
      } else {
        process.exit();
      }
    }
  });
}

const clients = []
Async.timesLimit(2500, 50, function(n, next) {
  const channel = getChannel();
  channel.once('attached', () => {
    clients.push(n);
    console.log('Client', n, 'attached')
    channel.on('detached', () => {
      clients.splice(clients.indexOf(n), 1)
      console.log('Client', n, 'detached')
    });
    next()
  });
  channel.subscribe('count', (message) => {
    console.log(message.data.count, 'clients connected. Elapsed time', Math.round(new Date().getTime() - message.data.broadcastAt), 'ms')
  })
}, function() {
  console.log('All clients connected in ', new Date().getTime() - startTime, 'ms')
  promptForPublish();
})

