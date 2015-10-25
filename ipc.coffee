ipc = require 'ipc'

ipc.send 'msg', 'ping'

ipc.on 'reply', (arg) ->
  console.log arg
  document.getElementById("image-placeholder").innerHTML =
    "<img src=\"http://www.wellclean.com/wp-content/themes/artgallery_3.0/images/car3.png\"></img>"
