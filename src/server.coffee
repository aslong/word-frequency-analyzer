debug                        = require('debug')('wfa:server')
ERRORS                       = require('./constants/word_frequency_analyzer/http_api_errors')
http                         = require('http')
Url                          = require('url')
WordFrequencyAnalyzerHTTPApi = require('./word_frequency_analyzer_http_api')

{ readStream, sendErrorToStreamAsJSON, sendSuccessToStreamAsJSON } = require('./utils')

PORT = 5000

server = http.createServer (request, response) ->
  url = request.url
  { pathname, query } = Url.parse(url, true)

  if pathname is "/ping"
    return response.end('OK')

  apiMethod = WordFrequencyAnalyzerHTTPApi[pathname]
  if apiMethod?
    apiMethod(request, response, query)
  else
    sendErrorToStreamAsJSON(response, ERRORS.METHOD_NOT_EXIST("method #{pathname} does not exist"))

if require.main isnt module
  module.exports = server
else
  server.listen(PORT)
  debug("Server listening on port #{PORT}")
