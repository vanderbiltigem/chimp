core
====

The core abstractions being used here is the "buffer" and the "view."

# Buffer

The [buffer](../core/buffer.coffee) maintains all of the information related to editing. This currently consists of a smart text string class and a collection of attributes. Buffers can be constructed from and written to files, strings, or other data types that are isomorphic to genomic data.

# View

The [view](../core/view.coffee) is a method of representing the buffer as a user interface element. Views contain a reference to a buffer or [buffer-like](#transducers) object, and present some interface to the user. Views may modify buffers in some specified way. The most obvious view is a rich text editor. Some less obvious ones include a reverse-complement text editor (which saves as a valid buffer, which is why it's so cool), and a webGL fun colorful 3D representation of a buffer.

# To Find Out
## Transducers
Transducers accept a "buffer-like" (something that implements the buffer interface, which may be a buffer) and return a "buffer-like" such that all buffer operations on the returned object are modified in some way (reverse complemented, for example).

One example of this might be a "reverse complement" transducer which accepts a `buffer-like` and returns a `buffer-like` such that retrieving buffer text from the transducer results in the text being reverse-complemented from the source `buffer-like` object, and modifying it results in the reverse complement of the modifications being written to the source buffer.

If this is supported, this would likely require a more finer-grained `buffer-like` interface for performance reasons. Writing the entirety of a genome, then reverse complementing it on every save operation is pretty costly and doesn't scale. Definitely would need a more incremental operation.
