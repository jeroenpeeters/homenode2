express     = require 'express'
bodyParser  = require 'body-parser'
helpers     = require './helpers'
app         = express()

module.exports = (config, eventBus)->
  #app.use express.static 'src/public'
  #app.use bodyParser.urlencoded extended: false
  app.use bodyParser.json()

  app.get '/api/v1/events', (req, res) ->
    res.setHeader 'Connection', 'Transfer-Encoding'
    res.setHeader 'Content-Type', 'text/event-stream; charset=utf-8'
    res.setHeader 'Transfer-Encoding', 'chunked'

    cb = (object) ->
      res.write "event: /object/state/changed\n"
      res.write "data: #{JSON.stringify object}\n\n"
    eventBus.on '/object/state/changed', cb

    res.on 'close', ->
      eventBus.removeListener '/object/state/changed', cb

  app.get '/api/v1/object/list', (req, res) ->
    res.json helpers.getObjects(config)
    res.end()

  app.post '/api/v1/object/:id/desired/state', (req, res) ->
      desiredState = req.body
      object = helpers.findObjectById config, req.params.id
      if not object
        res.json error: "Object does not exist"
        return res.end()

      for key of desiredState
        if object.state[key] == undefined
          res.json error: "Object does not support state property '#{key}'"
          return res.end()

      eventBus.emit '/object/state/desired', object, desiredState
      res.json object: object, desiredState: desiredState
      res.end()

  app.use express.static __dirname + '/public'
  app.get '*', (req, res) ->
    res.sendfile './public/index.html'

  server = app.listen config.web.port, ->
    host = server.address().address
    port = server.address().port
    console.log 'Listening', {host: host, port: port}
