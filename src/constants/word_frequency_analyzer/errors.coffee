# List of errors for the WordFrequencyAnalyzer
#
# @mixin
ERRORS =
  # Error for when the document string for the analyzer to parse is undefined
  #
  # @param [Object] trace a trace to include with the error
  # @return [String] JSON string containing the error structure
  MISSING_DOCUMENT_PARAM: (trace) -> JSON.stringify({ code: 'MDP1', message: 'You must specify a document as a string for parsing.', trace })

module.exports = ERRORS
