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

    eventBus.on '/object/state/changed', (object) ->
      res.write "event: /object/state/changed\n"
      res.write "data: #{JSON.stringify object}\n\n"

    res.on 'close', ->
      console.log 'client exited'

  app.get '/api/v1/object/list', (req, res) ->
    req.send JSON.stringify helpers.getObjects(config)
    req.end()

  app.post '/api/v1/object/state/desired', (req, res) ->
      data = req.body
      console.log 'data', data
      res.end()

  server = app.listen config.web.port, ->
    host = server.address().address
    port = server.address().port
    console.log 'Listening', {host: host, port: port}
