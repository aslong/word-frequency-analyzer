debug            = require('debug')('wfa:WordFrequencyAnalyzer')
ERRORS           = require('./constants/errors')
BinarySearchTree = require('./binary_search_additions')
_                = require('underscore')

class WordFrequencyAnalyzer

WordFrequencyAnalyzer.analyzeDocument = (documentString, countOfWordsReturn) ->
  if not documentString?
    throw new Error(ERRORS.MISSING_DOCUMENT_PARAM())

  documentLength = documentString.length
  maxWordsToReturn = countOfWordsReturn ? documentLength

  wordFrequencyTree = new BinarySearchTree()
  wordFrequencyHash = {}

  startPos = 0
  highestFrequency = 0
  nonStopCharFound = false

  _.each(documentString, (character, currentIndex) ->
    if character in [' ', ',', '.', '?', '!']
      # Check to see if we have seen any valid characters when processing the current word. If we haven't, 
      # we shouldn't parse the chars out and try to process something that is probably garbage characters.
      if nonStopCharFound
        newWord = extractRootWord(documentString, startPos, currentIndex)
        wordFrequency = incrementWordFrequency(wordFrequencyHash, wordFrequencyTree, newWord)
        highestFrequency = wordFrequency if highestFrequency < wordFrequency
      # Reset our word start and end pointers to find the next word. Also set that we haven't seen a valid word char.
      startPos = currentIndex + 1
      nonStopCharFound = false
    # We are at the end of the document but haven't found the end of the word, so this must be the end of 
    # the last word.
    else if (currentIndex + 1 is documentLength)
      newWord = extractRootWord(documentString, startPos, documentLength)
      wordFrequency = incrementWordFrequency(wordFrequencyHash, wordFrequencyTree, newWord)
      highestFrequency = wordFrequency if highestFrequency < wordFrequency
    else
      nonStopCharFound = true
  )

  return wordFrequencyTree.betweenBoundsReverseTillCount({ $lte: highestFrequency, $gte: 1 }, maxWordsToReturn)

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
