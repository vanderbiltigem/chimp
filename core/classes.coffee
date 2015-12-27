Obj = require '../lib/objects'

# TODO: make marker smart, as described in /doc/core.md
makeMarker = (ind) -> {index: ind}

# base class which keeps all state in memory
class Buffer
  # consider using some wrapper over arraybuffer instead of string internally if
  # algorithms require it for speed / it's easier to marshal back and forth
  # between native code / it's hard to store entire genomes in memory at once
  constructor: (@str = '') ->
    @markers = []

  getLength: -> @str.length

  insertAt: (str, ind) ->
    len = str.length
    for mark in @markers
      # FIXME: for now, all marks have move-on-insert-at behavior (similar to
      # emacs's insert-before-markers)
      if mark.index >= ind then mark.index += len
    @str = @str[0..ind-1] + str + @str[ind..]
    @

  # up to AND INCLUDING end
  deleteRegion: (beg, end) ->
    len = end - beg + 1
    for mark in @markers
      if beg < mark.index < end then mark.index = beg
      else if mark.index >= end then mark.index -= len
    @str = @str[0..beg-1] + @str[end+1..]
    @

  # up to AND INCLUDING end
  getSubseq: (beg, end) -> @str[beg..end]

  insertMarkerAt: (ind) ->
    @markers.push makeMarker ind
    @

  getMarkers: -> @markers

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

MakeTransducerFromObject = (obj) -> ->
  ret = Object.create @
  ret[k] = v for k, v of obj
  ret

MakeMixinFromTransducers = (obj) ->
  ret = {}
  ret[k] = MakeTransducerFromObject v for k, v of obj
  ret

IUPACDNAComplement =
  'A': 'T'
  'T': 'A'
  'G': 'C'
  'C': 'G'
  'U': 'A'
  'R': 'Y'
  'Y': 'R'
  'S': 'S'
  'W': 'W'
  'K': 'M'
  'M': 'K'
  'B': 'V'
  'V': 'B'
  'D': 'H'
  'H': 'D'
  'N': 'N'
  '-': '-'

reverseString = (str) -> str.split('').reverse().join('')
doComplement = (str) -> str.split('').map((e) -> IUPACDNAComplement[e]).join('')

Transducers = MakeMixinFromTransducers
  # TODO: gotta figure out how to transduce markers too
  reverseComplement:
    insertAt: (str, ind) ->
      complemented = doComplement str
      indexFromRight = @getLength() - (ind - 1) - complemented.length
      Object.getPrototypeOf(@).insertAt(
        reverseString(complemented), indexFromRight)
      @
    deleteRegion: (beg, end) ->
      begIndexFromRight = @getLength() - (beg + 1)
      endIndex = begIndexFromRight - (end - beg)
      Object.getPrototypeOf(@).deleteRegion(endIndex, begIndexFromRight)
      @
    getSubseq: (beg, end) ->
      begIndexFromRight = @getLength() - (beg + 1)
      endIndex = begIndexFromRight - (end - beg)
      reverseString(
        doComplement(
          Object.getPrototypeOf(@).getSubseq(endIndex, begIndexFromRight)))

# "basic" buffer class, still abstract, hooks up to some physical file to
# implement Buffer methods using "low-level" read/write/seek operations. assumes
# file is a plaintext file, and represents the string contents of the buffer
# exactly
# TODO: make this deal with our sweet new file format that does in/dels easily
# also make this cache modifications until save
class File extends Buffer
  save: ->

# includes transduction mixins (reverse complement, etc), and adds support for
# annotations with some sweet new member functions
# TODO: make this deal with our sweet new genetic file format
class GeneticFile extends File
  Obj.mix @, Transducers
