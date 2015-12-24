# smart strings and attributes

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
