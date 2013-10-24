debug                 = require('debug')('test:wfa:WordFrequencyAnalyzer:spec')
ERRORS                = require('../../src/constants/errors')
WordFrequencyAnalyzer = require('../../src/word_frequency_analyzer')
_                     = require('underscore')

#
# WordFrequencyAnalyzer Performance
#
describe 'WordFrequencyAnalyzer Performance', ->
  describe "defaults", () ->
    it "100 documents", () ->
      start = Date.now()
      for i in [0..100]
        document = "Notebooks are fun. Fun for many. Fun for  all."
        wordList = WordFrequencyAnalyzer.analyzeDocument(document, 4)
        wordList.should.have.length(4)
        wordList[0].should.eql('Fun')
        wordList[1].should.eql('for')
        wordList[2].should.eql('Notebooks')
        wordList[3].should.eql('are')
      end = Date.now()
      debug("#{end-start}ms")

    it "1,000 documents", () ->
      start = Date.now()
      for i in [0..1000]
        document = "Notebooks are fun. Fun for many. Fun for  all."
        wordList = WordFrequencyAnalyzer.analyzeDocument(document, 4)
        wordList.should.have.length(4)
        wordList[0].should.eql('Fun')
        wordList[1].should.eql('for')
        wordList[2].should.eql('Notebooks')
        wordList[3].should.eql('are')
      end = Date.now()
      debug("#{end-start}ms")

    it "10,000 documents", () ->
      start = Date.now()
      for i in [0..10000]
        document = "Notebooks are fun. Fun for many. Fun for  all."
        wordList = WordFrequencyAnalyzer.analyzeDocument(document, 4)
        wordList.should.have.length(4)
        wordList[0].should.eql('Fun')
        wordList[1].should.eql('for')
        wordList[2].should.eql('Notebooks')
        wordList[3].should.eql('are')
      end = Date.now()
      debug("#{end-start}ms")

    it "100,000 documents", () ->
      start = Date.now()
      for i in [0..100000]
        document = "Notebooks are fun. Fun for many. Fun for  all."
        wordList = WordFrequencyAnalyzer.analyzeDocument(document, 4)
        wordList.should.have.length(4)
        wordList[0].should.eql('Fun')
        wordList[1].should.eql('for')
        wordList[2].should.eql('Notebooks')
        wordList[3].should.eql('are')
      end = Date.now()
      debug("#{end-start}ms")

  describe "case sensitivity enabled", () ->
    it "100 documents", () ->
      start = Date.now()
      for i in [0..100]
        document = "Notebooks are fun. Fun for many. Fun for  all."
        wordList = WordFrequencyAnalyzer.analyzeDocumentWithOptions(document, 4, { caseSensitivityEnabled: true })
        wordList.should.have.length(4)
        wordList[0].should.eql('fun')
        wordList[1].should.eql('for')
        wordList[2].should.eql('notebooks')
        wordList[3].should.eql('are')
      end = Date.now()
      debug("#{end-start}ms")

    it "1,000 documents", () ->
      start = Date.now()
      for i in [0..1000]
        document = "Notebooks are fun. Fun for many. Fun for  all."
        wordList = WordFrequencyAnalyzer.analyzeDocumentWithOptions(document, 4, { caseSensitivityEnabled: true })
        wordList.should.have.length(4)
        wordList[0].should.eql('fun')
        wordList[1].should.eql('for')
        wordList[2].should.eql('notebooks')
        wordList[3].should.eql('are')
      end = Date.now()
      debug("#{end-start}ms")

    it "10,000 documents", () ->
      start = Date.now()
      for i in [0..10000]
        document = "Notebooks are fun. Fun for many. Fun for  all."
        wordList = WordFrequencyAnalyzer.analyzeDocumentWithOptions(document, 4, { caseSensitivityEnabled: true })
        wordList.should.have.length(4)
        wordList[0].should.eql('fun')
        wordList[1].should.eql('for')
        wordList[2].should.eql('notebooks')
        wordList[3].should.eql('are')
      end = Date.now()
      debug("#{end-start}ms")

    it "100,000 documents", () ->
      start = Date.now()
      for i in [0..100000]
        document = "Notebooks are fun. Fun for many. Fun for  all."
        wordList = WordFrequencyAnalyzer.analyzeDocumentWithOptions(document, 4, { caseSensitivityEnabled: true })
        wordList.should.have.length(4)
        wordList[0].should.eql('fun')
        wordList[1].should.eql('for')
        wordList[2].should.eql('notebooks')
        wordList[3].should.eql('are')
      end = Date.now()
      debug("#{end-start}ms")
