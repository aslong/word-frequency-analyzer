# List of errors for the WordFrequencyAnalyzer http api
#
# @mixin
WORD_FREQUENCY_ANALYZER_HTTP_API_ERRORS =
  # Error for when the document string for the analyzer to parse is undefined
  #
  # @param [Object] trace a trace to include with the error
  # @return [Object] error object with trace appended
  INCOMING_STREAM_PARSE_ERROR: (trace) -> { code: 'IS01', message: "Couldn't parse incoming request data stream", trace }

  # Error for when the options header specified for parsing is not formed properly
  #
  # @param [Object] trace a trace to include with the error
  # @return [Object] error object with trace appended
  PARSER_HEADER_OPTIONS_PARSE_ERROR: (trace) -> { code: 'PH01', message: "Couldn't parse parser's incoming header options", trace }

  # Error for when analyzing the document fails inside the analyzer
  #
  # @param [Object] trace a trace to include with the error
  # @return [Object] error object with trace appended
  ANALYZE_DOCUMENT_ERROR: (trace) -> { code: 'AD01', message: "Was not able to analyze the incoming document data", trace }

  # Error for an api call when it is called using the the wrong HTTP method
  #
  # @param [Object] trace a trace to include with the error
  # @return [Object] error object with trace appended
  HTTP_METHOD_ERROR: (trace) -> { code: 'HM01', message: "Can not execute the given path using the given HTTP method", trace }

  # Error for an attempt to make an api call that isn't defined
  #
  # @param [Object] trace a trace to include with the error
  # @return [Object] error object with trace appended
  METHOD_NOT_EXIST: (trace) -> { code: 'HM02', message: "The method requested to execute does not exist", trace }

module.exports = WORD_FREQUENCY_ANALYZER_HTTP_API_ERRORS
