_       = require 'lodash'

module.exports =
  getObjects: getObjects =  (config) -> _.flatten (definition.objects for roomName, definition of config.rooms)
  findObjectById: (config, id) ->
    for object in getObjects config
      if object.id == id then return object
    null
