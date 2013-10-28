debug                 = require('debug')('test:wfa:WordFrequencyAnalyzer:spec')
ERRORS                = require('../../src/constants/word_frequency_analyzer/errors')
fs                    = require('fs')
WordFrequencyAnalyzer = require('../../src/word_frequency_analyzer')
_                     = require('underscore')

document = ""
#
# WordFrequencyAnalyzer Performance
#
describe 'WordFrequencyAnalyzer Performance', ->
  before (done) ->
    loadTestDocument "jfk_inaugrual.txt", (error, loadedDocument) ->
      document = loadedDocument
      done()

  describe "defaults", () ->
    it "1 document", () ->
      start = Date.now()
      wordList = WordFrequencyAnalyzer.analyzeDocument(document, 4)
      wordList.should.have.length(4)
      wordList[0].should.eql('the')
      wordList[1].should.eql('of')
      wordList[2].should.eql('to')
      wordList[3].should.eql('and')
      end = Date.now()
      debug("#{end-start}ms")

    it "100 documents", () ->
      start = Date.now()
      for i in [0..100]
        wordList = WordFrequencyAnalyzer.analyzeDocument(document, 4)
        wordList.should.have.length(4)
        wordList[0].should.eql('the')
        wordList[1].should.eql('of')
        wordList[2].should.eql('to')
        wordList[3].should.eql('and')
      end = Date.now()
      debug("#{end-start}ms")

    it "1,000 documents", () ->
      start = Date.now()
      for i in [0..1000]
        wordList = WordFrequencyAnalyzer.analyzeDocument(document, 4)
        wordList.should.have.length(4)
        wordList[0].should.eql('the')
        wordList[1].should.eql('of')
        wordList[2].should.eql('to')
        wordList[3].should.eql('and')
      end = Date.now()
      debug("#{end-start}ms")

  describe "case sensitivity enabled", () ->
    it "1 document", () ->
      start = Date.now()
      wordList = WordFrequencyAnalyzer.analyzeDocumentWithOptions(document, 4, { caseSensitivityEnabled: true })
      wordList.should.have.length(4)
      wordList[0].should.eql('the')
      wordList[1].should.eql('of')
      wordList[2].should.eql('to')
      wordList[3].should.eql('and')
      end = Date.now()
      debug("#{end-start}ms")

    it "100 documents", () ->
      start = Date.now()
      for i in [0..100]
        wordList = WordFrequencyAnalyzer.analyzeDocumentWithOptions(document, 4, { caseSensitivityEnabled: true })
        wordList.should.have.length(4)
        wordList[0].should.eql('the')
        wordList[1].should.eql('of')
        wordList[2].should.eql('to')
        wordList[3].should.eql('and')
      end = Date.now()
      debug("#{end-start}ms")

    it "1,000 documents", () ->
      start = Date.now()
      for i in [0..1000]
        wordList = WordFrequencyAnalyzer.analyzeDocumentWithOptions(document, 4, { caseSensitivityEnabled: true })
        wordList.should.have.length(4)
        wordList[0].should.eql('the')
        wordList[1].should.eql('of')
        wordList[2].should.eql('to')
        wordList[3].should.eql('and')
      end = Date.now()
      debug("#{end-start}ms")

  describe "filter stop words enabled", () ->
    it "1 document", () ->
      start = Date.now()
      wordList = WordFrequencyAnalyzer.analyzeDocumentWithOptions(document, 4, { filterStopWords: true })
      wordList.should.have.length(4)
      wordList[0].should.eql('we')
      wordList[1].should.eql('in')
      wordList[2].should.eql('our')
      wordList[3].should.eql('that')
      end = Date.now()
      debug("#{end-start}ms")

    it "100 documents", () ->
      start = Date.now()
      for i in [0..100]
        wordList = WordFrequencyAnalyzer.analyzeDocumentWithOptions(document, 4, { filterStopWords: true })
        wordList.should.have.length(4)
        wordList[0].should.eql('we')
        wordList[1].should.eql('in')
        wordList[2].should.eql('our')
        wordList[3].should.eql('that')
      end = Date.now()
      debug("#{end-start}ms")

    it "1,000 documents", () ->
      start = Date.now()
      for i in [0..1000]
        wordList = WordFrequencyAnalyzer.analyzeDocumentWithOptions(document, 4, { filterStopWords: true })
        wordList.should.have.length(4)
        wordList[0].should.eql('we')
        wordList[1].should.eql('in')
        wordList[2].should.eql('our')
        wordList[3].should.eql('that')
      end = Date.now()
      debug("#{end-start}ms")

  describe "extract full root word enabled", () ->
    it "100 documents", () ->
      start = Date.now()
      for i in [0..100]
        wordList = WordFrequencyAnalyzer.analyzeDocumentWithOptions(document, 4, { extractFullRootWord: true })
        wordList.should.have.length(4)
        wordList[0].should.eql('the')
        wordList[1].should.eql('of')
        wordList[2].should.eql('to')
        wordList[3].should.eql('and')
      end = Date.now()
      debug("#{end-start}ms")

    it "1,000 documents", () ->
      start = Date.now()
      for i in [0..1000]
        wordList = WordFrequencyAnalyzer.analyzeDocumentWithOptions(document, 4, { extractFullRootWord: true })
        wordList.should.have.length(4)
        wordList[0].should.eql('the')
        wordList[1].should.eql('of')
        wordList[2].should.eql('to')
        wordList[3].should.eql('and')
      end = Date.now()
      debug("#{end-start}ms")


loadTestDocument = (documentFilename, cb) ->
  fs.readFile "#{__dirname}/test_documents/#{documentFilename}", (err, data) ->
    if (err)
      return cb(err)

    cb(null, data.toString())
