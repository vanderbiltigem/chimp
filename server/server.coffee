fs = require 'fs'
http = require 'http'
StaticServer = require 'node-static'

fileServer = new StaticServer.Server()

portNum = 8080

startServer = (cb) ->
  http.createServer((req, res) ->
    (req.addListener 'end', -> fileServer.serve req, res).resume())
    .listen portNum, cb

module.exports = {startServer, portNum}
