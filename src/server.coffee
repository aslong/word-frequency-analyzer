debug                        = require('debug')('wfa:server')
cluster                      = require('cluster')
ERRORS                       = require('./constants/word_frequency_analyzer/http_api_errors')
http                         = require('http')
cpuCount                     = require('os').cpus().length
Url                          = require('url')
WordFrequencyAnalyzerHTTPApi = require('./word_frequency_analyzer_http_api')

{ readStream, sendErrorToStreamAsJSON, sendSuccessToStreamAsJSON } = require('./utils')

# If we are being run from a node command, and this is the main thread, fork worker processes that bind to the same port to allow processing
# of http requests across all the available cpus on the machine.
if cluster.isMaster and require.main is module
  # Fork workers.
  for i in [0...cpuCount]
    cluster.fork()

  cluster.on 'online', (worker) ->
    debug("Worker #{worker.process.pid} now online")

  cluster.on 'exit', (worker, code, signal) ->
    debug("Worker #{worker.process.pid} died. Restarting worker after signal #{signal ? code}")
    cluster.fork()

else
  PORT = 5000

  server = http.createServer (request, response) ->
    url = request.url
    { pathname, query } = Url.parse(url, true)

    if pathname is "/ping"
      return response.end('OK')
    else if pathname is "/favicon.ico"
      return response.end()

    apiMethod = WordFrequencyAnalyzerHTTPApi[pathname]
    if apiMethod?
      debug("Request for method #{pathname}")
      return apiMethod(request, response, query)
    else
      return sendErrorToStreamAsJSON(response, ERRORS.METHOD_NOT_EXIST("method #{pathname} does not exist"))

  if require.main isnt module
    module.exports = server
  else
    server.listen(PORT)
    debug("Server listening on port #{PORT}")
