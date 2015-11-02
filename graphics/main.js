var BrowserWindow, app, mainWindow;

app = require('app');

BrowserWindow = require('browser-window');

mainWindow = null;

app.on('window-all-closed', function() {
  return app.quit();
});

app.on('ready', function() {
  var ipc;
  mainWindow = new BrowserWindow({
    width: 800,
    height: 600
  });
  mainWindow.loadUrl("file://" + __dirname + "/index.html");
  ipc = require('ipc');
  ipc.on('msg', (function(_this) {
    return function(ev, arg) {
      console.log(arg);
      return ev.sender.send('reply', 'pong');
    };
  })(this));
  return mainWindow.on('closed', (function(_this) {
    return function() {
      return mainWindow = null;
    };
  })(this));
});
