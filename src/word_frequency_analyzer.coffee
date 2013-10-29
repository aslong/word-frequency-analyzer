debug                   = require('debug')('wfa:WordFrequencyAnalyzer')
ERRORS                  = require('./constants/word_frequency_analyzer/errors')
{ ReversibleAVLTree }   = require('./binary_tree_additions')
_                       = require('underscore')

{ PARSER_OPTIONS_KEYS, PARSER_OPTIONS_DEFAULTS }                         = require('./constants/word_frequency_analyzer/parser_options')
{ STOP_CHAR_HASH, STOP_WORD_FILTER_HASH, WORD_STEM_AND_MODIFIER_REGEXP } = require('./constants/word_frequency_analyzer/parser_definitions')

# Analyzer that takes a string of text and parses the words from it and records their frequency.
class WordFrequencyAnalyzer
  # Construct a new WordFrequencyAnalyzer
  #
  # @param [Object] options defines parsing options to the analyzer
  # @option options [String] language (default: 'EN') defines the language of the words in the document
  # @option options [Boolean] caseSensitivityEnabled (default: false) tells the parser to consider case when determining if two words are the same word
  # @option options [Boolean] filterStopWords (default: false) tells the parser to remove stop words from the frequency analysis
  # @option options [Boolean] extractFullRootWord (default: false) tells the parser to extract the root word when determining whether words are the same
  constructor: (options={}) ->
    @language = options[PARSER_OPTIONS_KEYS.LANGUAGE] ? PARSER_OPTIONS_DEFAULTS[PARSER_OPTIONS_KEYS.LANGUAGE]
    @caseSensitivityEnabled = options[PARSER_OPTIONS_KEYS.CASE_SENSITIVITY] ? PARSER_OPTIONS_DEFAULTS[PARSER_OPTIONS_KEYS.CASE_SENSITIVITY]
    @filterStopWordsEnabled = options[PARSER_OPTIONS_KEYS.FILTER_STOP_WORDS] ? PARSER_OPTIONS_DEFAULTS[PARSER_OPTIONS_KEYS.FILTER_STOP_WORDS]
    @extractFullRootWordEnabled = options[PARSER_OPTIONS_KEYS.EXTRACT_FULL_ROOT_WORD] ? PARSER_OPTIONS_DEFAULTS[PARSER_OPTIONS_KEYS.EXTRACT_FULL_ROOT_WORD]

    @LOCALIZED_STOP_CHAR_HASH = STOP_CHAR_HASH(@language)
    @LOCALIZED_STOP_WORD_HASH = STOP_WORD_FILTER_HASH(@language)
    @LOCALIZED_WORD_STEM_AND_MODIFIER_REGEXP = WORD_STEM_AND_MODIFIER_REGEXP(@language)

  # Get an generic id from the current parser's options
  #
  # @return [String] The generic id for the given parser with these options
  getParserOptionsId: () =>
    options = {}
    options[PARSER_OPTIONS_KEYS.LANGUAGE] = @language
    options[PARSER_OPTIONS_KEYS.CASE_SENSITIVITY] = @caseSensitivityEnabled
    options[PARSER_OPTIONS_KEYS.FILTER_STOP_WORDS] = @filterStopWordsEnabled
    options[PARSER_OPTIONS_KEYS.EXTRACT_FULL_ROOT_WORD] = @extractFullRootWordEnabled
    return WordFrequencyAnalyzer.getParserOptionsId(options)

  # Given a document represented as a string, return a list of the most frequently used words in the document,
  # sorted by frequency from high to low. Can specify as the second parameter the number of words to return in 
  # the list.
  #
  # @param [String] documentString A string of text to parse and analyze for word frequency
  # @param [Number] desiredWordListByFrequencyLength The max length of the returned word list
  # @return [Array<String>, Object, Object]
  #   <b>sortedWordsByFrequency</b> {Array<String>} The list of words that occurred in the documentString, sorted by frequency.
  #   <b>wordFrequencyTree</b> {Object} Tree structure where each node's key is the frequency and the values are words with
  #   that frequency.
  #   <b>wordFrequencyHash</b> {Object} Hash structure who's keys are words and values are frequencies.
  analyzeDocument: (documentString, desiredWordListByFrequencyLength) =>
    if not documentString?
      throw new Error(ERRORS.MISSING_DOCUMENT_PARAM())

    documentCharCount = documentString.length
    # Always ensure that if there isn't a desiredWordListByFrequencyLength that we at least return all the potential words that
    # are found in the documentString.
    numberWordsToReturn = desiredWordListByFrequencyLength ? documentCharCount

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
        # Reset our word start pointer to look for the start of the next word. 
        startPos = currentIndex + 1
        # Also set that we haven't seen a valid word char.
        nonStopCharFound = false
      # Are we at the end of the document but haven't found the end of a word, if so this must be the end of
      # the last word in the whole document. Pass the rest of the string to extractWord.
      else if (currentIndex + 1 is documentCharCount)
        newWord = @extractWord(documentString, startPos, documentCharCount)
      else
        nonStopCharFound = true

      # If we have a valid new word, increment it's frequency and update the highestFrequency if the new word is higher
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

    if not @caseSensitivityEnabled
      word = @removeCaseFromWord(word)

    if @extractFullRootWordEnabled
      word = @extractModifiersFromWord(word)

    if @filterStopWordsEnabled
      word = @filterStopWord(word)

    if word? and word.length > 0
      return word
    else
      return undefined

  # Given a word, remove any upper case characters that may exist and return the resulting string.
  #
  # @param [String] word the word to remove upper case characters from
  # @return [String] the word passed in with any upper case characters removed
  removeCaseFromWord: (word) =>
    return word.toLowerCase()

  # Given a word, extract any word modifiers that may exist on the word for the current analyzer's parsing options.
  #
  # @param [String] word the word to extract any modifiers from
  # @return [String] The extracted word with any word modifiers removed
  extractModifiersFromWord: (word) =>
    _.each(@LOCALIZED_WORD_STEM_AND_MODIFIER_REGEXP, (regexp) ->
      word = word.replace(regexp, '')
    )
    return word

  # Given a word, return it if it isn't a stop word. Return undefined if the word is a stop word.
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
  # @param [Number] desiredWordListByFrequencyLength the max number of words to return in the sorted list
  # @return [Array<String>] The list of words that occurred in the documentString, sorted by frequency
  @analyzeDocument: (documentString, desiredWordListByFrequencyLength) ->
    return @analyzeDocumentWithOptions(documentString, desiredWordListByFrequencyLength)

  # Analyze a string of text and override any of the analyzer's default options. Only returns the list of sorted words.
  #
  # @param [String] documentString the string of text to analyze
  # @param [Number] desiredWordListByFrequencyLength the max number of words to return in the sorted list
  # @param [Object] options any option that can be passed into the WordFrequencyAnalyzer's constructor
  # @return [Array<String>] The list of words that occurred in the documentString, sorted by frequency
  @analyzeDocumentWithOptions: (documentString, desiredWordListByFrequencyLength, options) ->
    englishAnalyzerFilterStopWordsDisabled = new @(options)
    { sortedWordsByFrequency } = englishAnalyzerFilterStopWordsDisabled.analyzeDocument(documentString, desiredWordListByFrequencyLength)
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

  # Get an generic id from a WordFrequencyAnalyzer parser's options object
  #
  # @param [Object] options a hash of words to frequency
  # @return [String] The generic id for the given parser with these options
  @getParserOptionsId: (options={}) ->
    language = if options[PARSER_OPTIONS_KEYS.LANGUAGE]? then options[PARSER_OPTIONS_KEYS.LANGUAGE] else PARSER_OPTIONS_DEFAULTS[PARSER_OPTIONS_KEYS.LANGUAGE]
    caseSensitivity = if options[PARSER_OPTIONS_KEYS.CASE_SENSITIVITY] then '-caseSensitivityEnabled' else ''
    filterStopWords = if options[PARSER_OPTIONS_KEYS.FILTER_STOP_WORDS] then '-filterStopWordsEnabled' else ''
    extractFullRootWord = if options[PARSER_OPTIONS_KEYS.EXTRACT_FULL_ROOT_WORD] then '-extractFullRootWordEnabled' else ''
    return "#{language}#{caseSensitivity}#{filterStopWords}#{extractFullRootWord}"

module.exports = WordFrequencyAnalyzer
