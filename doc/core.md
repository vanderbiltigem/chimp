core
====

The core abstractions being used here is the "buffer" and the "view."

# buffer

The [buffer](../core/buffer.coffee) maintains all of the information related to editing. This currently consists of a smart text string class and a collection of attributes. Buffers can be constructed from and written to files, strings, or other data types that are isomorphic to genomic data.

# view

The [view](../core/view.coffee) is a method of representing the buffer as a user interface element. Views contain a reference to a buffer or [buffer-like](#transducers) object, and present some interface to the user. Views may modify buffers in some specified way. The most obvious view is a rich text editor. Some less obvious ones include a reverse-complement text editor (which saves as a valid buffer, which is why it's so cool), and a webGL fun colorful 3D representation of a buffer.

# to find out
## transducers
do we want to have chains of buffer-like objects transforming buffers? or do we instead only have buffers, and methods that operate on them? could views just act upon something that wraps a buffer and extends its interface? not sure. sounds like a good idea though.
