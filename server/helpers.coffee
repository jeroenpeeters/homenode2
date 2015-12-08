_       = require 'lodash'

module.exports =
  getObjects: (config) -> _.flatten (definition.objects for roomName, definition of config.rooms)
