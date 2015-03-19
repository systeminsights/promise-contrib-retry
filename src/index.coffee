R = require 'ramda'
B = require 'bluebird'

# :: (Number, () -> Promise e a) -> Promise e a
later = (millis, f) ->
  new B((res, rej) -> setTimeout((-> f().then(res, rej)), millis))

# :: RetryPolicy e -> (() -> Promise e a) -> Promise e a
#
# Given a function returning a promise, retry the promise on rejection
# according to the retry policy.
#
retrying = R.curry (policy, f) ->
  f().then(undefined, (e) ->
    policy(e).fold(
      ((t) -> later(t._1, (-> retrying(t._2, f)))),
      (    -> B.reject(e))))

module.exports = retrying

