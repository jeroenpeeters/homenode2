#
# Plugin for Suncalc
#

_       = require 'lodash'
SunCalc = require 'suncalc'
helpers = require '../helpers'

module.exports = (config, eventBus) ->
  console.log 'Initializing Suncalc Control Plugin'
  setTimeout run(config, eventBus), 10000
  run(config, eventBus)()

run = (config, eventBus) -> ->
  di = SunCalc.getTimes new Date(new Date - 60000*30), config.suncalc.lat, config.suncalc.lng
  winners = selectWinners (evaluateCandidates di[prop], config.suncalc[prop] for prop of di when config.suncalc[prop])
  for winner in winners when !_.isMatch winner.object.state, winner.desiredState
    console.log "SunCalc is changing the state", winner
    eventBus.emit '/object/state/desired', winner.object, winner.desiredState

evaluateCandidates = (date, objects) ->
  if new Date() >= date
    date: date, objects: objects

selectWinners = (candidates) ->
  winners = {}
  for c in candidates when c
    for object in c.objects
      if !winners[object.object.id] or c.date > winners[object.object.id].date
        winners[object.object.id] = date: c.date, x: object
  (object: object.x.object, desiredState: object.x.desiredState, date: object.date for key,object of winners)
