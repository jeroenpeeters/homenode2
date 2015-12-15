_            = require 'lodash'
config       = require '../config'
EventEmitter = require 'events'

eventEmitter = new EventEmitter()
eventEmitter.setMaxListeners 50

web = require('./web') config, eventEmitter

# Initialize the plugins
for pluginName in config.plugins
  plugin = require "./#{pluginName}"
  plugin config, eventEmitter
