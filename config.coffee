require('./server/types').install @

schemerlamp       = @kaku('12493714', 0) @lamp 'Schemerlamp'
pianolamp         = @kaku('12493714', 1) @lamp 'Pianolamp'
schuurlamp_buiten = @x10('b1') @dimmable @lamp 'Schuurlamp buiten'
schuurlamp_binnen = @x10('b2') @dimmable @lamp 'Schuurlamp binnen'

rooms =
  Huiskamer:
    icon: 'home'
    objects: [ schemerlamp, pianolamp ]
  Tuin:
    icon: 'maps:local-florist'
    objects: [ schuurlamp_buiten, schuurlamp_binnen ]

module.exports =
  rooms: rooms
  plugins: [
    'protocols/x10'
  ]
  x10:
    mochad:
      host: '127.0.0.1'
      port: 1099
  web:
    port: 8080


#
# exports.people = [
#     name: 'Kim'
#     photo_url: '/images/people/kim.jpg'
#     location:
#       name: ''
#   ,
#     name: 'Jeroen'
#     photo_url: '/images/people/jeroen.jpg'
#     location:
#       name: ''
# ]
#
#
# # Models the thermostat state
# exports.thermostat =
#     current_temp : 0
#     heating_temp : 0
#     boiler_active : false
#
# #append an id to all devices
# uuid = require 'node-uuid'
# for device in exports.devices
#   device._id = uuid.v4()