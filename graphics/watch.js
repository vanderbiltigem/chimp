var coffeeRegex, spawn, watch;

spawn = require('child_process').spawn;

watch = require('node-watch');

coffeeRegex = /\.coffee$/g;

watch('.', function(f) {
  var makeProc;
  if (f.match(coffeeRegex)) {
    makeProc = spawn('make', process.argv);
    makeProc.stdout.pipe(process.stdout);
    makeProc.stderr.pipe(process.stderr);
    return makeProc.on('exit', function(code) {
      return process.exit(code);
    });
  }
});
