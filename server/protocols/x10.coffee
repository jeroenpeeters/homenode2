#
# Plugin for X10 devices
#

net     = require 'net'
helpers = require '../helpers'

module.exports = (config, eventEmitter) ->
  console.log 'Initializing X10 Protocol Plugin'
  if not config.x10
    console.error 'No X10 plugin configuration found'
    process.exit 1

  readX10Events config, eventEmitter

  eventEmitter.on '/object/state/desired', (device, desiredState) ->
    return unless device.x10
    console.log 'desired = ',desiredState
    if desiredState.on == true
      sendOn device.x10.address, config
    else
      sendOff device.x10.address, config

  # pubsub.on '/device/on', (device) ->
  #   if device.config.type == 'x10' then sendOn device.config.address, app.config
  #
  # pubsub.on '/device/off', (device) ->
  #   if device.config.type == 'x10' then sendOff device.config.address, app.config

# X10 Commands code -->
sendx10 = (command, config) ->
  client = new net.Socket()
  client.connect config.x10.mochad.port, config.x10.mochad.host, ->
    console.log "CONNECTED TO: " + config.x10.mochad.host + ":" + config.x10.mochad.port
    client.write command
    client.destroy()

sendOn = (device_address, config) ->
  console.log "pl " + device_address + " on"
  sendx10 "pl " + device_address + " on\n", config

sendOff = (device_address, config) ->
  console.log "pl " + device_address + " off"
  sendx10 "pl " + device_address + " off\n", config


# <-- X10 Commands code

# Parse status information from Mochad -->
commandPattern = /(\d{2})\/(\d{2})\s(\d{2}):(\d{2}):(\d{2})\s(Tx|Rx)\s(PL|RF)\sHouseUnit:\s(.\d)\r?\n?(\d{2})\/(\d{2})\s(\d{2}):(\d{2}):(\d{2})\s(Tx|Rx)\s(PL|RF)\sHouse:\s(.)\sFunc:\s(On|Off)\r?\n?/
splitCommandsPattern = /(.+\n.+\n?)/
unwrapCommand = (line) ->
  commandPattern.exec line

splitCommands = (data) ->
  array = data.split(splitCommandsPattern)
  newArray = Array()
  i = 0

  while i < array.length
    newArray.push array[i]  if array[i].length > 0
    i++
  newArray


# <-- Parse status information from Mochad

# Receive X10 Events from Mochad -->
readX10Events = (config, eventEmitter)->

  client = new net.Socket()
  client.connect config.x10.mochad.port, config.x10.mochad.host, ->
    console.log "Connected to Mochad"
    return

  client.on "data", (dataArray) ->
    console.log "onData", String(dataArray)
    data = "" + String(dataArray) # needed to convert char array to string
    commands = splitCommands(data)
    i = 0

    while i < commands.length
      cmdArray = unwrapCommand(commands[i])
      # ignore messages that are not understood, like:
      # 12/14 19:58:57 Invalid checksum
      if cmdArray.length >= 17
        cmd =
          txrx: cmdArray[6]
          iface: cmdArray[7]
          address: cmdArray[8]
          house: cmdArray[16]
          cmd: cmdArray[17]

        for object in helpers.getObjects config
          if object.x10?.address is cmd.address.toLowerCase()
            object.state.on = cmd.cmd.toLowerCase() is 'on'
            eventEmitter.emit '/object/state/changed', object
            #pubsub.publish '/model/devices', device
      i++

  client.on "error", (error) ->
    console.log "There was a problem connecting to Mochad, check your configuration!", error.code
    process.exit 1


# <-- Receive X10 Events from Mochad
