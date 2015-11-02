app = require 'app'
BrowserWindow = require 'browser-window'
ipc = require 'ipc'

Server = require './server/server'

mainWindow = null

app.on 'window-all-closed', ->
  app.quit()

Server.startServer ->
  app.on 'ready', ->
    mainWindow = new BrowserWindow({width: 800, height: 600})
    mainWindow.loadUrl "http://localhost:#{Server.portNum}"

    ipc.on 'msg', (ev, arg) =>
      console.log arg
      ev.sender.send 'reply', 'pong'

    mainWindow.on 'closed', =>
      mainWindow = null
