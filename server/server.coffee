fs = require 'fs'
http = require 'http'
StaticServer = require 'node-static'

fileServer = new StaticServer.Server()

startServer = (cb) ->
  http.createServer((req, res) ->
    (req.addListener 'end', -> fileServer.serve req, res).resume())
    # 0 listens on random port
    .listen 0, -> cb @address().port

module.exports = {startServer}
