_     = require 'lodash'
hash  = require 'object-hash'

extend = (def1, def2) ->
  ext = _.extend def1, def2
  ext.id = hash.sha1 ext
  ext

device = (definition) ->
  extend {}, definition

module.exports =

  lamp: (name) -> device
    name: name
    type: 'lamp'
    state: on: false

  dimmable: (device) -> extend device, dimmable: true

  x10:  (address) -> (device) -> extend device, x10: address: address

  kaku: (group, address) -> (device) -> extend device,
    kaku: group:group, address: address

  install: (target) ->
    target[type] = @[type] for type of @ when type isnt 'install'
