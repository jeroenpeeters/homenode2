_            = require 'lodash'
config       = require '../config'
EventEmitter = require 'events'

eventEmitter = new EventEmitter()

web = require('./web') config, eventEmitter

# Initialize the plugins
for pluginName in config.plugins
  plugin = require "./#{pluginName}"
  plugin config, eventEmitter


eventEmitter.on '/object/state/changed', (object) ->
  console.log 'object state changed', object

setTimeout ->
  eventEmitter.emit '/object/state/desired', config.rooms.Tuin.objects[1]
, 10000
