debug       = require('debug')('wfa:WordFrequencyAnalyzer')
{ AVLTree } = require('./binary_tree_additions')
ERRORS      = require('./constants/errors')
_           = require('underscore')

{ STOP_CHAR_HASH, STOP_WORD_FILTER_HASH, WORD_STEM_AND_MODIFIER_REGEXP } = require('./constants/word_frequency_analyzer')

class WordFrequencyAnalyzer
  constructor: (options={}) ->
    @language = options.language ? 'EN'
    @caseSensitivityEnabled = options.caseSensitivityEnabled ? false
    @filterStopWordsEnabled = options.filterStopWords ? false
    @extractFullRootWordEnabled = options.extractFullRootWord ? false

    @LOCALIZED_STOP_CHAR_HASH = STOP_CHAR_HASH(@language)
    @LOCALIZED_STOP_WORD_HASH = STOP_WORD_FILTER_HASH(@language)
    @LOCALIZED_WORD_STEM_AND_MODIFIER_REGEXP = WORD_STEM_AND_MODIFIER_REGEXP(@language)

  analyzeDocument: (documentString, desiredWordListLengthByFrequency) =>
    if not documentString?
      throw new Error(ERRORS.MISSING_DOCUMENT_PARAM())

    documentCharCount = documentString.length
    numberWordsToReturn = desiredWordListLengthByFrequency ? documentCharCount

    wordFrequencyTree = new AVLTree()
    wordFrequencyHash = {}

    startPos = 0
    highestFrequency = 0
    nonStopCharFound = false

    _.each(documentString, (currentChar, currentIndex) =>
      # If the current character in the string is a "stop character", a character that marks the expected
      # end of a word, we may have a new word to process.
      if @LOCALIZED_STOP_CHAR_HASH[currentChar]?
        # Check to see if we have seen any valid characters when processing the current word. If we haven't,
        # we shouldn't parse the chars out and try to process something that is probably garbage characters.
        if nonStopCharFound
          newWord = @extractRootWord(documentString, startPos, currentIndex)
        # Reset our word start pointer to find the next word. Also set that we haven't seen a valid word char.
        startPos = currentIndex + 1
        nonStopCharFound = false
      # Are we at the end of the document but haven't found the end of a word, if so this must be the end of
      # the last word in the whole document.
      else if (currentIndex + 1 is documentCharCount)
        newWord = @extractRootWord(documentString, startPos, documentCharCount)
      else
        nonStopCharFound = true

      if newWord?
        newWordFrequency = WordFrequencyAnalyzer.incrementWordFrequency(wordFrequencyHash, wordFrequencyTree, newWord)
        highestFrequency = newWordFrequency if highestFrequency < newWordFrequency
        newWord = undefined
    )

    return {
      sortedWordsByFrequency: wordFrequencyTree.betweenBoundsReverseTillCount({ $lte: highestFrequency, $gte: 1 }, numberWordsToReturn)
      wordFrequencyTree
      wordFrequencyHash
    }

  extractRootWord: (documentString, startPos, endPos) =>
    word = documentString.substring(startPos, endPos)

    if @caseSensitivityEnabled
      word = word.toLowerCase()

    if @extractFullRootWordEnabled
      word = @extractModifiersFromRootWord(word)

    if @filterStopWordsEnabled
      word = @filterStopWord(word)

    if word? and word.length > 0
      return word
    else
      return undefined

  extractModifiersFromRootWord: (word) =>
    _.each(@LOCALIZED_WORD_STEM_AND_MODIFIER_REGEXP, (regexp) ->
      word = word.replace(regexp, '')
    )
    return word

  filterStopWord: (word) =>
    if @LOCALIZED_STOP_WORD_HASH[word]?
      return undefined
    else
      return word

# Default analyzeDocument function. Doesn't filter out stop words and uses the language EN
WordFrequencyAnalyzer.analyzeDocument = (documentString, desiredWordListLengthByFrequency) ->
  return WordFrequencyAnalyzer.analyzeDocumentWithOptions(documentString, desiredWordListLengthByFrequency)

WordFrequencyAnalyzer.analyzeDocumentWithOptions = (documentString, desiredWordListLengthByFrequency, options) ->
  englishAnalyzerFilterStopWordsDisabled = new WordFrequencyAnalyzer(options)
  { sortedWordsByFrequency } = englishAnalyzerFilterStopWordsDisabled.analyzeDocument(documentString, desiredWordListLengthByFrequency)
  return sortedWordsByFrequency

WordFrequencyAnalyzer.incrementWordFrequency = (wordFrequencyHash, wordFrequencyTree, word) ->
  # Set/Update the count for the occurance of this word
  wordFrequency = (wordFrequencyHash[word] ? 0) + 1
  wordFrequencyHash[word] = wordFrequency

  # Update the binary tree that is holding a sorted word frequency list
  if wordFrequency isnt 1
    wordFrequencyTree.delete(wordFrequency - 1, word)
  wordFrequencyTree.insert(wordFrequency, word)

  return wordFrequency

module.exports = WordFrequencyAnalyzer
