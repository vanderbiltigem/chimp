fs = require 'fs'

[infile, outfile, num, block_length] = process.argv[2..]

numBytes = fs.statSync(infile).size
outstream = fs.createWriteStream outfile, {flags: 'a'}
range = (numBytes - (block_length + 1))
for [1..num] by 1
  num = Math.floor(Math.random() * range)
  outstream.write(num + ',\n')
outstream.write '};\n'
outstream.end()
