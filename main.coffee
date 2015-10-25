app = require 'app'
BrowserWindow = require 'browser-window'

mainWindow = null

app.on 'window-all-closed', ->
  app.quit()

app.on 'ready', ->
  mainWindow = new BrowserWindow({width: 800, height: 600})
  mainWindow.loadUrl "file://#{__dirname}/index.html"

  ipc = require 'ipc'

  ipc.on 'msg', (ev, arg) =>
    console.log arg
    ev.sender.send 'reply', 'pong'

  mainWindow.on 'closed', =>
    mainWindow = null
