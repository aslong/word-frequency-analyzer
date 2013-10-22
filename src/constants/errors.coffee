module.exports =
  MISSING_DOCUMENT_PARAM: (trace) -> JSON.stringify({ code: 'MDP1', message: 'You must specify a document as a string for parsing.', trace })
