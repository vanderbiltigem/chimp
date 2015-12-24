core
====

The core abstractions being used here is the "buffer" and the "view."

# Base Classes
The [Buffer](#Buffer) and [View](#View) base classes exist so that buffer types can be specialized for the specific data type (for example, allowing us to used different representations for genomic data and regular text). Specialization of these classes hopefully allows for greater efficiency when representing data such as genomic data, which may be especially large, and also highly structured.

## Buffer
The [buffer](../core/buffer.coffee) maintains all of the information related to editing. This currently consists of a smart text string class and a collection of attributes. Buffers can be constructed from and written to files, strings, or other data types that are isomorphic to genomic data.

## View
The [view](../core/view.coffee) is a method of representing the buffer as a user interface element. Views contain a reference to a buffer or [buffer-like](#transducers) object, and present some interface to the user. Views may modify buffers in some specified way. The most obvious view is a rich text editor. Some less obvious ones include a reverse-complement text editor (which saves as a valid buffer, which is why it's so cool), and a webGL fun colorful 3D representation of a buffer.

## Derived Classes
# GeneticBuffer
Buffers should be some representation of genomic data. Stream of consciousness to follow.

- the concern here is to find an abstract representation of genomic data that can scale to gbs of data while allowing fine grained editing operations

- oh and also this representation should be able to be quickly queried for a given subset of the sequence

- consider representations which only require as much space as is requested (+O(1) obv)

- also maybe wanna be able to get aggregate stats by running through entire sequence quickly

- consider mmap
  - hard to see how that would work if the format doesn't have the sequence all together in memory
  - however, can have some idea about where sequence starts, where ends, any extraneous data in between, so we know exactly the file byte range to read
  - consider new format (binary?) which is faster to convert to desired representation
    - ensure the format is robust to new bases
  - can be used for read-only buffers in a special ro mode if don't need write and offers greater speed in some way
  - insertions in the middle still kill mmap

- consider some kind of lazy tree to implement lazy memory mapping while allowing insertions in the middle
  - hard to implement
  - can be faster than insert with an mmap?
    - requires shifting the whole file over
  - difficult to see how this avoids shifting the whole file over upon insertions, unless an intermediate representation is used
  - maybe we can require our own intermediate representation (own file format) for saves and allow import-export with normal formats?
    - this representation could be append-only, maybe, and then only do compaction when it gets super long
    - this is absolutely terrible for sequential scans
      - sequential scans are nice for just reading a sequence into memory, and also running many types of algorithms on them
      - can be implemented by scanning original, then running over all indels, but that's pretty bad for caching compared to a for loop over an mmaped region

- so big (competing) issues are:
1. being able to run over the data in order, quickly
2. being able to support arbitrary indels
  - emacs has probably solved this already, as have other (fast) text editors (e.g. vim)
      - although they mostly optimize for human editing (e.g. short lined-files) which we dgaf about

## GeneticView

# Built On Top
## Transducers
Transducers accept a "buffer-like" (something that implements the buffer interface, which may be a buffer) and return a "buffer-like" such that all buffer operations on the returned object are modified in some way (reverse complemented, for example).

One example of this might be a "reverse complement" transducer which accepts a `buffer-like` and returns a `buffer-like` such that retrieving buffer text from the transducer results in the text being reverse-complemented from the source `buffer-like` object, and modifying it results in the reverse complement of the modifications being written to the source buffer.

If this is supported, this would likely require a more finer-grained `buffer-like` interface for performance reasons. Writing the entirety of a genome, then reverse complementing it on every save operation is pretty costly and doesn't scale. Definitely would need a more incremental operation.

## Markers
A marker is something that moves along with any text insertions within a buffer.

- Possibly implementable using transducers?
  - Probably not doable, although transducers will be very important
    - i think markers added to a specific `buffer-like` would be shared among all levels of transduction (since editing of any transduction (probably) also edits the original buffer)
    - because of the possibility of tree-like transductions (multiple different transducers applied to the same original `buffer-like`), it is probably best to either:
        1. find all markers of all levels of the transduction tree
        2. flatten all markers to the base buffer (probs better for performance)

## Streamers
A streamer is 1. a funny name and 2. something that generates a stream or reads from a stream. The API for this is as follows:
