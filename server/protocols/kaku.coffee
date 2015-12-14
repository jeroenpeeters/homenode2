#
# Plugin for KlikAanKlikUit (kaku) devices
#

exec     = require('child_process').exec
helpers  = require '../helpers'

module.exports = (config, eventEmitter) ->
  console.log 'Initializing KlikAanKlikUit Protocol Plugin'
  if not config.kaku
    console.error 'No KlikAanKlikUit plugin configuration found'
    process.exit 1

  eventEmitter.on '/object/state/desired', (device, desiredState) ->
    return unless device.kaku
    console.log 'desired = ',desiredState
    console.log 'device', device
    if desiredState.on == true
      exec "#{config.kaku.cmd} -g #{device.kaku.group} -n #{device.kaku.address} on"
      device.state.on = true
    else
      exec "#{config.kaku.cmd} -g #{device.kaku.group} -n #{device.kaku.address} off"
      device.state.on = false

    eventEmitter.emit '/object/state/changed', device
