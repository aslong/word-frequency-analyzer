debug                 = require('debug')('wfa:index')
WordFrequencyAnalyzer = require('./word_frequency_analyzer')

###*
# This is the main README for the documentation
#
# @class **README**
# @module **README**
###

debug(JSON.stringify(WordFrequencyAnalyzer.analyzeDocument("hi")))
