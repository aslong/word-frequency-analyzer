debug                 = require('debug')('test:wfa:WordFrequencyAnalyzer:spec')
ERRORS                = require('../../src/constants/word_frequency_analyzer/errors')
WordFrequencyAnalyzer = require('../../src/word_frequency_analyzer')
_                     = require('underscore')

#
# WordFrequencyAnalyzer Spec
#
describe 'WordFrequencyAnalyzer Spec', ->
  describe 'Error Handling', () ->
    it 'should throw an exception if both args are not defined', () ->
      (() -> WordFrequencyAnalyzer.analyzeDocument()).should.throw(ERRORS.MISSING_DOCUMENT_PARAM())

    it 'shouldn\'t throw an exception if both args are defined', () ->
      (() -> WordFrequencyAnalyzer.analyzeDocument('my document', 4)).should.not.throw(ERRORS.MISSING_DOCUMENT_PARAM())

  describe 'Analysis Validation', () ->
    describe 'word recognition', () ->
      it 'should return a word with punction before or after as still being the same word', () ->
        words = ["surround.", ".surround", " surround", ".surround.", ". surround", "'surround'"]
        document = words.join(' ')
        wordList = WordFrequencyAnalyzer.analyzeDocumentWithOptions(document, 5, { extractFullRootWord: true })
        _.isArray(wordList).should.eql.true
        wordList.should.have.length(1)
        wordList.should.include('surround')

      it 'should return a word with different punction before or after as still being the same word', () ->
        words = ["different?", "!different", " different", ".different!", "! different", "'different"]
        document = words.join(' ')
        wordList = WordFrequencyAnalyzer.analyzeDocumentWithOptions(document, 5, { extractFullRootWord: true })
        _.isArray(wordList).should.eql.true
        wordList.should.have.length(1)
        wordList.should.include('different')

      it 'should return a word with odd casing as being the same word', () ->
        words = ["Same", "same", "saMe", "saME", "samE"]
        document = words.join(' ')
        wordList = WordFrequencyAnalyzer.analyzeDocumentWithOptions(document, 5, { caseSensitivityEnabled: true })
        _.isArray(wordList).should.eql.true
        wordList.should.have.length(1)
        wordList.should.include('same')

    describe 'countOfWordsReturn arg specified', () ->
      it 'should return an empty list for an empty document string', () ->
        wordList = WordFrequencyAnalyzer.analyzeDocument('', 5)
        _.isArray(wordList).should.eql.true
        wordList.should.have.length(0)

      it 'should return all the words in a single word document', () ->
        document = 'Test'
        wordList = WordFrequencyAnalyzer.analyzeDocument(document, 5)
        wordList.should.have.length(1)
        wordList[0].should.eql('Test')

      it 'should return all the words in a multi word document without duplicates', () ->
        words = ["Test", "the", "document"]
        document = words.join(' ')
        wordList = WordFrequencyAnalyzer.analyzeDocument(document, 5)
        wordList.should.have.length(3)
        wordList[0].should.eql(words[0])
        wordList[1].should.eql(words[1])
        wordList[2].should.eql(words[2])

      it 'should return all the words in a multi word document with one duplicate', () ->
        document = "Notebooks are fun. Fun for many."
        wordList = WordFrequencyAnalyzer.analyzeDocumentWithOptions(document, 5, { caseSensitivityEnabled: true })
        wordList.should.have.length(5)
        wordList[0].should.eql('fun')
        wordList[1].should.eql('notebooks')
        wordList[2].should.eql('are')
        wordList[3].should.eql('for')
        wordList[4].should.eql('many')

      it 'should return all the words in a multi word document with multiple duplicates', () ->
        document = "Notebooks are fun. Fun for many. Fun for  all."
        wordList = WordFrequencyAnalyzer.analyzeDocumentWithOptions(document, 4, { caseSensitivityEnabled: true })
        wordList.should.have.length(4)
        wordList[0].should.eql('fun')
        wordList[1].should.eql('for')
        wordList[2].should.eql('notebooks')
        wordList[3].should.eql('are')

      it 'should return all the words in a multi word document with a complex punctuation duplicates', () ->
        document = "Test the document. Document's can be tricky to parse"
        wordList = WordFrequencyAnalyzer.analyzeDocumentWithOptions(document, 3, { caseSensitivityEnabled: true, extractFullRootWord: true })
        wordList.should.have.length(3)
        wordList[0].should.eql('document')
        wordList[1].should.eql('test')
        wordList[2].should.eql('the')

    describe 'countOfWordsReturn arg not specified', () ->
      it 'should return an empty list for an empty document string', () ->
        wordList = WordFrequencyAnalyzer.analyzeDocument('')
        _.isArray(wordList).should.eql.true
        wordList.should.have.length(0)

      it 'should return all the words in a single word document', () ->
        document = 'Test'
        wordList = WordFrequencyAnalyzer.analyzeDocument(document)
        wordList.should.have.length(1)
        wordList[0].should.eql('Test')

      it 'should return all the words in a single word document with a trailing space', () ->
        document = "test "
        wordList = WordFrequencyAnalyzer.analyzeDocument(document)
        wordList.should.have.length(1)
        wordList[0].should.eql('test')

      it 'should return all the words in a multi word document without duplicates', () ->
        document = "Test the document"
        wordList = WordFrequencyAnalyzer.analyzeDocument(document)
        wordList.should.have.length(3)
        wordList[0].should.eql('Test')
        wordList[1].should.eql('the')
        wordList[2].should.eql('document')
