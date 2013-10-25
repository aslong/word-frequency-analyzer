###*
# List of errors for the WordFrequencyAnalyzer
#
# @module errors
###
module.exports =
  ###*
  # Error for when the document string for the analyzer to parse is undefined
  #
  # @for errors
  # @method MISSING_DOCUMENT_PARAM
  # @params {object} trace a trace to include with the error
  ###
  MISSING_DOCUMENT_PARAM: (trace) -> JSON.stringify({ code: 'MDP1', message: 'You must specify a document as a string for parsing.', trace })
