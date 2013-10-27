debug                 = require('debug')('wfa:WordFrequencyAnalyzer')
ERRORS                = require('./constants/word_frequency_analyzer/errors')
{ ReversibleAVLTree } = require('./binary_tree_additions')
_                     = require('underscore')

{ STOP_CHAR_HASH, STOP_WORD_FILTER_HASH, WORD_STEM_AND_MODIFIER_REGEXP } = require('./constants/word_frequency_analyzer/parser_definitions')

# Analyzer that takes a string of text and parses the words from it and records their frequency.
class WordFrequencyAnalyzer
  # Construct a new WordFrequencyAnalyzer
  #
  # @param [Object] options defines parsing options to the analyzer
  # @option options [String] language (default: 'EN') defines the language of the words in the document
  # @option options [Boolean] caseSensitivityEnabled (default: false) tells the parser to ignore case when determining if two words are the same word
  # @option options [Boolean] filterStopWords (default: false) tells the parser to remove stop words from the frequency analysis
  # @option options [Boolean] extractFullRootWord (default: false) tells the parser to extract the root word when determining whether words are the same
  constructor: (options={}) ->
    @language = options.language ? 'EN'
    @caseSensitivityEnabled = options.caseSensitivityEnabled ? false
    @filterStopWordsEnabled = options.filterStopWords ? false
    @extractFullRootWordEnabled = options.extractFullRootWord ? false

    @LOCALIZED_STOP_CHAR_HASH = STOP_CHAR_HASH(@language)
    @LOCALIZED_STOP_WORD_HASH = STOP_WORD_FILTER_HASH(@language)
    @LOCALIZED_WORD_STEM_AND_MODIFIER_REGEXP = WORD_STEM_AND_MODIFIER_REGEXP(@language)

  # Given a document represented as a string return a list of the most frequently used words in the document,
  # sorted by frequency from high to low. Can specify as the second parameter the number of words to return in 
  # the list.
  #
  # @param [String] documentString A string of test to parse and analyze for word frequency
  # @param [Number] desiredWordListLengthByFrequency The max length of the returned word list
  # @return [Array<String>, Object, Object]
  #   <b>sortedWordsByFrequency</b> {Array<String>} The list of words that occurred in the documentString, sorted by frequency.
  #   <b>wordFrequencyTree</b> {Object} Tree structure where each node's key is the frequency and the values are words with
  #   that frequency.
  #   <b>wordFrequencyHash</b> {Object} Hash structure who's keys are words and values are frequencies.
  analyzeDocument: (documentString, desiredWordListLengthByFrequency) =>
    if not documentString?
      throw new Error(ERRORS.MISSING_DOCUMENT_PARAM())

    documentCharCount = documentString.length
    numberWordsToReturn = desiredWordListLengthByFrequency ? documentCharCount

    wordFrequencyTree = new ReversibleAVLTree()
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
          newWord = @extractWord(documentString, startPos, currentIndex)
        # Reset our word start pointer to find the next word. Also set that we haven't seen a valid word char.
        startPos = currentIndex + 1
        nonStopCharFound = false
      # Are we at the end of the document but haven't found the end of a word, if so this must be the end of
      # the last word in the whole document.
      else if (currentIndex + 1 is documentCharCount)
        newWord = @extractWord(documentString, startPos, documentCharCount)
      else
        nonStopCharFound = true

      if newWord?
        newWordFrequency = WordFrequencyAnalyzer.incrementWordFrequency(wordFrequencyHash, wordFrequencyTree, newWord)
        highestFrequency = newWordFrequency if highestFrequency < newWordFrequency
        newWord = undefined
    )

    return {
      sortedWordsByFrequency: wordFrequencyTree.betweenBoundsReversedTillCount({ $lte: highestFrequency, $gte: 1 }, numberWordsToReturn)
      wordFrequencyTree
      wordFrequencyHash
    }

  # Given a string, start index, and end index, extract the word from the string and apply any parsing options enabled
  # for the current analyzer.
  #
  # @param [String] documentString string to extract the word from
  # @param [Number] startIndex index to start the extraction
  # @param [Number] endIndex index to end the extraction
  # @return [String] The extracted word with any parsing options applied
  extractWord: (documentString, startIndex, endIndex) =>
    word = documentString.substring(startIndex, endIndex)

    if @caseSensitivityEnabled
      word = word.toLowerCase()

    if @extractFullRootWordEnabled
      word = @extractModifiersFromWord(word)

    if @filterStopWordsEnabled
      word = @filterStopWord(word)

    if word? and word.length > 0
      return word
    else
      return undefined

  # Given a word extract any word modifiers that may exist on the word for the current analyzer's parsing options.
  #
  # @param [String] word the word to extract any modifiers from
  # @return [String] The extracted word with any word modifiers removed
  extractModifiersFromWord: (word) =>
    _.each(@LOCALIZED_WORD_STEM_AND_MODIFIER_REGEXP, (regexp) ->
      word = word.replace(regexp, '')
    )
    return word

  # Given a word return it if it isn't a stop word. Return undefined if the word is a stop word.
  #
  # @param [String] word the word to possibly fiter out if it is a stop word
  # @return [String] the word passed in if it isn't a stop word. undefined if the word is a stop word
  filterStopWord: (word) =>
    if @LOCALIZED_STOP_WORD_HASH[word]?
      return undefined
    else
      return word

  # Analyze a string of text using the analyzer's defaults. Very limited parsing intellegence. Doesn't filter or try to get the roots of words. Only returns the list of sorted words.
  #
  # @param [String] documentString the string of text to analyze
  # @param [Number] desiredWordListLengthByFrequency the max number of words to return in the sorted list
  # @return [Array<String>] The list of words that occurred in the documentString, sorted by frequency
  @analyzeDocument: (documentString, desiredWordListLengthByFrequency) ->
    return @analyzeDocumentWithOptions(documentString, desiredWordListLengthByFrequency)

  # Analyze a string of text and override any of the analyzer's default options. Only returns the list of sorted words.
  #
  # @param [String] documentString the string of text to analyze
  # @param [Number] desiredWordListLengthByFrequency the max number of words to return in the sorted list
  # @param [Object] options any option that can be passed into the WordFrequencyAnalyzer's constructor
  # @return [Array<String>] The list of words that occurred in the documentString, sorted by frequency
  @analyzeDocumentWithOptions: (documentString, desiredWordListLengthByFrequency, options) ->
    englishAnalyzerFilterStopWordsDisabled = new @(options)
    { sortedWordsByFrequency } = englishAnalyzerFilterStopWordsDisabled.analyzeDocument(documentString, desiredWordListLengthByFrequency)
    return sortedWordsByFrequency

  # Update the frequency of a word by one using the structures returned from an analyzeDocument call.
  #
  # @param [Object] wordFrequencyHash a hash of words to frequency
  # @param [Object] wordFrequencyTree a binary tree of nodes whose keys are frequencies and values are words with that frequency
  # @param [String] word the desired word for incrementing the frequency
  # @return [Number] The updated frequency of the word that was incremented
  @incrementWordFrequency: (wordFrequencyHash, wordFrequencyTree, word) ->
    # Set/Update the count for the occurrence of this word
    wordFrequency = (wordFrequencyHash[word] ? 0) + 1
    wordFrequencyHash[word] = wordFrequency

    # Update the binary tree that is holding a sorted word frequency list
    if wordFrequency isnt 1
      wordFrequencyTree.delete(wordFrequency - 1, word)
    wordFrequencyTree.insert(wordFrequency, word)

    return wordFrequency

module.exports = WordFrequencyAnalyzer
