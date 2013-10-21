debug = require('debug')('test:wfa:WordFrequencyAnalyzer:spec')
WordFrequencyAnalyzer = require('../../src/word_frequency_analyzer.coffee')

#
# WordFrequencyAnalyzer Spec
#
describe 'WordFrequencyAnalyzer Spec', ->

  it 'should pass', () ->
    WordFrequencyAnalyzer.analyzeDocument()
    true.should.eql(true)
