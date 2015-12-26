# smart strings and attributes

Obj = require '../lib/objects'

class Buffer
  # consider using some wrapper over arraybuffer instead of string internally if
  # algorithms require it for speed / it's easier to marshal back and forth
  # between native code / it's hard to store entire genomes in memory at once
  constructor: ->
    @markers = []

  getLength: ->

  insertAt: (str, ind) ->

  deleteRegion: (beg, end) ->

  insertMarkerAt: (ind) ->

  getMarkers: ->

# transducers take a function which modifies any given string of the input
# buffer, and an inverse function which performs the opposite

# transducers, when created, have the source buffer as their prototype. this
# allows transductions of buffers to forward all functionality not changed by
# the transducer to the source buffer. this also means that all modifications
# done will immediately impact the source buffer (unless we add a
# process.nextTick for some reason), which means the source buffer is always
# up-to-date, no matter how long the transduction chain is

# take a look at
# https://javascriptweblog.wordpress.com/2011/05/31/a-fresh-look-at-javascript-mixins/
# if more complexity is required
Transducers =
  reverseComplement: ->
    obj = Object.create @
    # TODO: override some of obj's functions, maybe add some state
    obj

# "basic" buffer class, still abstract, hooks up to some physical file to
# implement Buffer methods using "low-level" read/write/seek operations. assumes
# file is a plaintext file, and represents the string contents of the buffer
# exactly
class File extends Buffer

# includes transduction mixins (reverse complement, etc), and adds support for
# annotations with some sweet new member functions
class GeneticFile extends File
  Obj.mix @, Transducers

# implements the required methods for File/GeneticFile to call for FASTA files
class FASTAFile extends GeneticFile
