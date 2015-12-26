# smart strings and attributes

Obj = require '../lib/objects'

class Buffer
  # consider using some wrapper over arraybuffer instead of string internally if
  # algorithms require it for speed / it's easier to marshal back and forth
  # between native code / it's hard to store entire genomes in memory at once
  constructor: (@str = '', @attrs = {}) ->
    @markers = []

  length: ->

  insertAt: (str, ind) ->

  deleteRegion: (beg, end) ->

  insertMarkerAt: (ind) ->

  getMarkers: ->

# take a look at
# https://javascriptweblog.wordpress.com/2011/05/31/a-fresh-look-at-javascript-mixins/
# if more complexity is required
Transducers =
  reverseComplement: ->

# "basic" buffer class, still abstract, hooks up to some physical file to
# implement Buffer methods
class File extends Buffer

# implements required methods for File for plaintext files
class TextFile extends File

# includes transduction mixins (reverse complement, etc)
class GeneticFile extends File
  Obj.mix @, Transducers

# implements the required methods for File to call for FASTA files
class FASTAFile extends GeneticFile
