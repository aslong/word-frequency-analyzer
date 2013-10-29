# List of constants when dealing with WordFrequencyAnalyzer parser options
#
# List of option names and their defaults:
#   - language: 'EN'
#   - caseSensitivityEnabled: false
#   - filterStopWords: false
#   - extractFullRootWord: false
#
# List of available languages:
#   - EN
#
# @mixin
PARSER_OPTIONS = {}

PARSER_OPTIONS_KEYS =
  LANGUAGE: 'language'
  CASE_SENSITIVITY: 'caseSensitivityEnabled'
  FILTER_STOP_WORDS: 'filterStopWords'
  EXTRACT_FULL_ROOT_WORD: 'extractFullRootWord'

PARSER_OPTIONS_LANGUAGES =
  EN: 'EN'

PARSER_OPTIONS_DEFAULTS = {}
PARSER_OPTIONS_DEFAULTS[PARSER_OPTIONS_KEYS.LANGUAGE] = PARSER_OPTIONS_LANGUAGES.EN
PARSER_OPTIONS_DEFAULTS[PARSER_OPTIONS_KEYS.CASE_SENSITIVITY] = false
PARSER_OPTIONS_DEFAULTS[PARSER_OPTIONS_KEYS.FILTER_STOP_WORDS] = false
PARSER_OPTIONS_DEFAULTS[PARSER_OPTIONS_KEYS.EXTRACT_FULL_ROOT_WORD] = false

module.exports = { PARSER_OPTIONS_DEFAULTS, PARSER_OPTIONS_KEYS, PARSER_OPTIONS_LANGUAGES }
