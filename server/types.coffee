_ = require 'lodash'

module.exports =
  lamp: (name) ->
    name: name
    type: 'lamp'
    state: on: false

  dimmable: (device) -> _.extend device, dimmable: true

  x10:  (address) -> (device) -> _.extend device, x10: address: address

  kaku: (group, address) -> (device) -> _.extend device,
    kaku: group:group, address: address

  install: (target) ->
    target[type] = @[type] for type of @ when type isnt 'install'
