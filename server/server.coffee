fs = require 'fs'
http = require 'http'
static = require 'node-static'

fileServer = new static.Server()

portNum = 8080

startServer = (cb) ->
  http.createServer((req, res) ->
    (req.addListener 'end', -> fileServer.serve req, res).resume())
    .listen portNum, cb

module.exports = {startServer, portNum}
