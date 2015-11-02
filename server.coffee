fs = require 'fs'
http = require 'http'

portNum = 8080

startServer = (cb) ->
  http.createServer((req, res) ->
    res.writeHead '200', {'Content-Type': 'text/html'}
    fs.createReadStream('index.html').pipe res)
    .listen portNum, cb

module.exports = {startServer}
