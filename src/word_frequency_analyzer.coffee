debug   = require('debug')('wfa:WordFrequencyAnalyzer')
ERRORS  = require('./constants/errors')
AVLTree = require('./binary_tree_additions').AVLTree
_       = require('underscore')

class WordFrequencyAnalyzer

WordFrequencyAnalyzer.analyzeDocument = (documentString, desiredWordListLengthByFrequency) ->
  if not documentString?
    throw new Error(ERRORS.MISSING_DOCUMENT_PARAM())

  documentCharCount = documentString.length
  numberWordsToReturn = desiredWordListLengthByFrequency ? documentCharCount

  wordFrequencyTree = new AVLTree()
  wordFrequencyHash = {}

  startPos = 0
  highestFrequency = 0
  nonStopCharFound = false

  _.each(documentString, (currentChar, currentIndex) ->
    # If the current character in the string is a "stop character", a character that marks the expected
    # end of a word, we may have a new word to process.
    if currentChar in [' ', ',', '.', '?', '!', ';', ':', '(', ')', '[', ']', '{', '}', '\"', '\n', '\t']
      # Check to see if we have seen any valid characters when processing the current word. If we haven't, 
      # we shouldn't parse the chars out and try to process something that is probably garbage characters.
      if nonStopCharFound
        newWord = extractRootWord(documentString, startPos, currentIndex)
        newWordFrequency = incrementWordFrequency(wordFrequencyHash, wordFrequencyTree, newWord)
        highestFrequency = newWordFrequency if highestFrequency < newWordFrequency
      # Reset our word start pointer to find the next word. Also set that we haven't seen a valid word char.
      startPos = currentIndex + 1
      nonStopCharFound = false
    # Are we at the end of the document but haven't found the end of a word, if so this must be the end of
    # the last word in the whole document.
    else if (currentIndex + 1 is documentCharCount)
      newWord = extractRootWord(documentString, startPos, documentCharCount)
      newWordFrequency = incrementWordFrequency(wordFrequencyHash, wordFrequencyTree, newWord)
      highestFrequency = newWordFrequency if highestFrequency < newWordFrequency
    else
      nonStopCharFound = true
  )

  return wordFrequencyTree.betweenBoundsReverseTillCount({ $lte: highestFrequency, $gte: 1 }, numberWordsToReturn)

extractRootWord = (documentString, startPos, endPos) ->
  return documentString.substring(startPos, endPos).toLowerCase().replace(/'s$/, '')

incrementWordFrequency = (wordFrequencyHash, wordFrequencyTree, word) ->
  # Set/Update the count for the occurance of this word
  wordFrequency = (wordFrequencyHash[word] ? 0) + 1
  wordFrequencyHash[word] = wordFrequency

  # Update the binary tree that is holding a sorted word frequency list
  if wordFrequency isnt 1
    wordFrequencyTree.delete(wordFrequency - 1, word)
  wordFrequencyTree.insert(wordFrequency, word)

  return wordFrequency

module.exports = WordFrequencyAnalyzer
