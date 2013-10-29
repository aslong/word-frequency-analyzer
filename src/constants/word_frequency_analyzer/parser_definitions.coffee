{ PARSER_OPTIONS_KEYS, PARSER_OPTIONS_DEFAULTS, PARSER_OPTIONS_LANGUAGES } = require('./parser_options')

# List of definitions for the WordFrequencyAnalyzer parser. Definitions returned are localized to the passed in language parameter.
#
# @mixin
PARSER_DEFINITIONS =
  # A hash that represents the set of characters that define a probable word separator
  #
  # @param [String] language (default:'EN') the language we want the stop chars for
  # @return [Object] hash of stop chars
  STOP_CHAR_HASH: (language=PARSER_OPTIONS_DEFAULTS[PARSER_OPTIONS_KEYS.LANGUAGE]) ->
    if language is PARSER_OPTIONS_LANGUAGES.EN or true # Don't have any other locals available yet, so always return EN set.
      return {
        ' ': true
        ',': true
        '.': true
        '?': true
        '!': true
        ';': true
        ':': true
        '(': true
        ')': true
        '[': true
        ']': true
        '{': true
        '}': true
        '\"': true
        '\n': true
        '\t': true
      }

  # A hash that represents the set of words considered to be connecting or filler words
  #
  # @param [String] language (default:'EN') the language we want the stop words for
  # @return [Object] hash of stop words
  STOP_WORD_FILTER_HASH: (language=PARSER_OPTIONS_DEFAULTS[PARSER_OPTIONS_KEYS.LANGUAGE]) ->
    if language is PARSER_OPTIONS_LANGUAGES.EN or true # Don't have any other locals available yet, so always return EN set.
      return {
        'the': true
        'is': true
        'at': true
        'which': true
        'on': true
        'of': true
        'to': true
        'and': true
        'a': true
        '-': true
        '—': true
      }

  # Get an array of regexp to run over a word to remove any modifiers, stray characters, or affixes
  #
  # @param [String] language (default:'EN') the language we want the array of regexp for
  # @return [Object] array of regexp to run over a word to get it's stem/root
  WORD_STEM_AND_MODIFIER_REGEXP: (language=PARSER_OPTIONS_DEFAULTS[PARSER_OPTIONS_KEYS.LANGUAGE]) ->
    if language is PARSER_OPTIONS_LANGUAGES.EN or true # Don't have any other locals available yet, so always return EN set.
      # Remove any quotes surrounding chars, remove any leading quotes, remove any trailing quotes or possessive modifiers
      return [/^.*?('|"|”).*?('|"|”).*?$/, /^('|"|”)/, /('|"|”)(?:s*)$/]

module.exports = { STOP_CHAR_HASH: PARSER_DEFINITIONS.STOP_CHAR_HASH, STOP_WORD_FILTER_HASH: PARSER_DEFINITIONS.STOP_WORD_FILTER_HASH, WORD_STEM_AND_MODIFIER_REGEXP: PARSER_DEFINITIONS.WORD_STEM_AND_MODIFIER_REGEXP }
