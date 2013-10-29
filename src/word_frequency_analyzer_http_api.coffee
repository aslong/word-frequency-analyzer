debug                 = require('debug')('wfa:WordFrequencyAnalyzerHTTPApi')
ERRORS                = require('./constants/word_frequency_analyzer/http_api_errors')
WordFrequencyAnalyzer = require('./word_frequency_analyzer')
_                     = require('underscore')

{ readStream, sendErrorToStreamAsJSON, sendSuccessToStreamAsJSON } = require('./utils')

OPTIONS_HEADER_KEY = 'options'

# Object to store a cache of current initialized analyzers.
current_analyzers = {}
default_wfa = new WordFrequencyAnalyzer()
current_analyzers[default_wfa.getParserOptionsId()] = default_wfa

# The HTTP API for the WordFrequencyAnalyzer
#
# /analyzeDocument<br/>
# ---
# Method: POST
#
# Given a document sent via an http request body, return a list of the most frequently used words in the document,
# sorted by frequency from high to low. Can specify a parameter to limit the number of words to return in 
# the list.
#
# Ex: /analyzeDocument?desiredWordListByFrequencyLength=4
#
# To specify options to set on the parser, use the options header. Any option that can be passed into the analyzer's
# constructor can be used.
#
# @mixin
WordFrequencyAnalyzerHTTPApi =
  '/analyzeDocument': (request, response, args) ->
    if request.method is 'POST'
      readStream request, false, (error, documentString) ->
        if error?
          return sendErrorToStreamAsJSON(response, ERRORS.INCOMING_STREAM_PARSE_ERROR(error.message))

        # Pull off any parser options from the options header, and parse them from JSON
        options = request.headers[OPTIONS_HEADER_KEY]
        try
          if options? and typeof(options) is "string"
            options = JSON.parse(options)
        catch error
          return sendErrorToStreamAsJSON(response, ERRORS.PARSER_HEADER_OPTIONS_PARSE_ERROR(error.message))

        # Get our cached Analyzer from our cache if it exists. Otherwise create it and add it to the cache.
        parserOptionsId = WordFrequencyAnalyzer.getParserOptionsId(options)
        wfa = current_analyzers[parserOptionsId]
        if not wfa?
          wfa = new WordFrequencyAnalyzer(options)
          current_analyzers[parserOptionsId] = wfa

        # Analyze the document and return the response
        try
          stats = wfa.analyzeDocument(documentString, args?.desiredWordListByFrequencyLength)
        catch error
          return sendErrorToStreamAsJSON(response, ERRORS.ANALYZE_DOCUMENT_ERROR(error.message))

        return sendSuccessToStreamAsJSON(response, stats?.sortedWordsByFrequency)
    else
      return sendErrorToStreamAsJSON(response, ERRORS.HTTP_METHOD_ERROR("HTTP method should be 'POST'"))

module.exports = WordFrequencyAnalyzerHTTPApi
