debug = require('debug')('wfa:utils')
# Various utility functions
#
# @mixin
Utils =
  # Given a stream, read in all of the data until an end event is emitted.
  #
  # @param [Stream] stream A string of text to parse and analyze for word frequency
  # @param [Boolean] desiredWordListByFrequencyLength The max length of the returned word list
  # @param [Function] cb The callback to call when finished. Uses the (error, result) format
  readStream: (stream, shouldParse, cb) ->
    data = ""
    stream.on 'data', (chunk) ->
      data += chunk
    stream.on 'end', () ->
      if shouldParse
        try
          data = JSON.parse(data)
        catch error
          cb(error, null)

      cb(null, data)
    stream.on 'error', (e) ->
      cb(e)

  # Given a stream, send a success response as JSON and end the stream.
  #
  # @param [Stream] stream an open stream to the client for receiving data
  # @param [Object] response the object to stringify into json and send on the stream
  sendSuccessToStreamAsJSON: (stream, response) ->
    response = JSON.stringify(response)
    stream.writeHead(200, {
      'Content-Length': Buffer.byteLength(response),
      'Content-Type': 'application/json'
    })
    stream.end(response)

  # Given a stream, send an error response as JSON and end the stream.
  #
  # @param [Stream] stream an open stream to the client for receiving data
  # @param [Object] error the error object to stringify into json and send on the stream
  sendErrorToStreamAsJSON: (stream, error) ->
    error = JSON.stringify(error)
    stream.writeHead(501, {
      'Content-Length': Buffer.byteLength(error),
      'Content-Type': 'application/json'
    })
    stream.end(error)
    debug("Sent error #{error} to stream")


module.exports = Utils
