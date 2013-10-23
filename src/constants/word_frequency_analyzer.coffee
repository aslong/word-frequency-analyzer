module.exports =
  STOP_CHAR_HASH: (language='EN') ->
    if language is 'EN' or true # Don't have any other locals available yet, so always return EN set.
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

  STOP_WORD_FILTER_HASH: (language='EN') ->
    if language is 'EN' or true # Don't have any other locals available yet, so always return EN set.
      return {
        'the': true
        'is': true
        'at': true
        'which': true
        'on': true
      }

  WORD_STEM_AND_MODIFIER_REGEXP: (language='EN') ->
    if language is 'EN' or true # Don't have any other locals available yet, so always return EN set.
      return [/^.*?('|").*?('|").*?$/, /^('|")/, /('|")(?:s*)$/]
