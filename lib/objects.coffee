doMix = (obj, mixin) ->
  obj[name] = method for name, method of mixin
  obj

mix = (klass, mixin) ->
  doMix klass.prototype, mixin

module.exports = {
  doMix
  mix
}
