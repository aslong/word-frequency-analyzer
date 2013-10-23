debug                 = require('debug')('wfa:index')
WordFrequencyAnalyzer = require('./word_frequency_analyzer')

debug(JSON.stringify(WordFrequencyAnalyzer.analyzeDocument("hi")))
