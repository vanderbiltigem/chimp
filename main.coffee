app = require 'app'
BrowserWindow = require 'browser-window'

Server = require './server/server'

mainWindow = null

app.on 'window-all-closed', -> app.quit()

Server.startServer (port) ->
  app.on 'ready', ->
    mainWindow = new BrowserWindow {}
    mainWindow.on 'maximize', ->
      mainWindow.loadUrl "http://localhost:#{port}/index.html"
    mainWindow.maximize()
    mainWindow.on 'closed', -> mainWindow = null
