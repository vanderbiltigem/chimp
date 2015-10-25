{spawn} = require 'child_process'
watch = require 'node-watch'

coffeeRegex = /\.coffee$/g

watch '.', (f) ->
  if f.match coffeeRegex
    makeProc = spawn 'make', process.argv
    makeProc.stdout.pipe process.stdout
    makeProc.stderr.pipe process.stderr
    makeProc.on 'exit', (code) -> process.exit code
