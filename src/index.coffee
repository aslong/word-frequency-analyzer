debug                 = require('debug')('wfa:index')
http                  = require('http')
Url                   = require('url')
WordFrequencyAnalyzer = require('./word_frequency_analyzer')

PORT = 8000

###*
# This is the main README for the documentation
#
# @class **README**
# @module **README**
###

server = http.createServer (request, response) ->
  url = request.url
  { pathname, query } = Url.parse(url, true)

  if serverMethods[pathname]?
    serverMethods[pathname](request, response, query)
  else
    response.end(JSON.stringify('method doesnt exist'))

serverMethods = 
  '/analyzeDocument': (request, response, args) ->
    documentString = ""
    request.on 'data', (chunk) ->
      documentString += chunk
    request.on 'end', () ->
      wfa = new WordFrequencyAnalyzer()
      stats = wfa.analyzeDocument(documentString, args?.desiredWordListByFrequencyLength)

      response.end(JSON.stringify(stats.sortedWordsByFrequency))

if require.main isnt module
  module.exports = server
else
  server.listen(PORT)
  debug("Server listening on port #{PORT}")
