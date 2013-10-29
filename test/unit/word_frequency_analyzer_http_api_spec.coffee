debug          = require('debug')('test:wfa:WordFrequencyAnalyzer:http_api_spec')
ERRORS         = require('../../src/constants/word_frequency_analyzer/http_api_errors')
http           = require('http')
{ readStream } = require('../../src/utils')
server         = require('../../src/server')
should         = require('should')
_              = require('underscore')

PORT = 5005

#
# WordFrequencyAnalyzer HTTP API
#
describe 'WordFrequencyAnalyzer HTTP api Spec', () ->
  before (done) ->
    server.listen(PORT)
    done()

  after (done) ->
    server.close()
    done()

  describe 'Health Tests', () ->
    it 'should return OK when the server is up', (done) ->
      options = 
        port: PORT,
        hostname: 'localhost',
        method: 'GET',
        path: '/ping'

      req = http.request(options, (response) ->
        response.statusCode.should.eql(200)
        readStream response, false, (error, responseData) ->
          should.not.exist(error)
          responseData.should.eql('OK')
          done()
      )

      req.end()

  describe 'Response Tests', () ->
    it 'should get a 501 if the method at path doesn\'t exist', (done) ->
      options = 
        port: PORT,
        hostname: 'localhost',
        method: 'POST',
        path: '/iDon\'tExist'

      req = http.request(options, (response) ->
        response.statusCode.should.eql(501)
        readStream response, true, (error, responseData) ->
          should.not.exist(error)
          responseData.should.eql(ERRORS.METHOD_NOT_EXIST("method /iDon%27tExist does not exist"))
          done()
      )

      req.end()

    it 'should get a 501 if the method used at path isn\'t \'POST\'', (done) ->
      options = 
        port: PORT,
        hostname: 'localhost',
        method: 'GET',
        path: '/analyzeDocument'

      req = http.request(options, (response) ->
        response.statusCode.should.eql(501)
        readStream response, true, (error, responseData) ->
          should.not.exist(error)
          responseData.should.eql(ERRORS.HTTP_METHOD_ERROR("HTTP method should be 'POST'"))
          done()
      )

      req.end()

    it 'should get a 501 if the options header is not valid json', (done) ->
      options = 
        port: PORT,
        hostname: 'localhost',
        method: 'POST',
        path: '/analyzeDocument'
        headers:
          options: '322f3efe2 }{'

      req = http.request(options, (response) ->
        response.statusCode.should.eql(501)
        readStream response, true, (error, responseData) ->
          should.not.exist(error)
          responseData.should.eql(ERRORS.PARSER_HEADER_OPTIONS_PARSE_ERROR("Unexpected token f"))
          done()
      )

      req.end()

    it 'should get an empty array response if no document data is sent', (done) ->
      options = 
        port: PORT,
        hostname: 'localhost',
        method: 'POST',
        path: '/analyzeDocument'

      req = http.request(options, (response) ->
        readStream response, true, (error, responseData) ->
          should.not.exist(error)
          _.isArray(responseData).should.eql.true
          responseData.should.have.length(0)
          done()
      )

      req.end()

    it 'should get a successful response without any args specified', (done) ->
      options = 
        port: PORT,
        hostname: 'localhost',
        method: 'POST',
        path: '/analyzeDocument'

      req = http.request(options, (response) ->
        readStream response, true, (error, responseData) ->
          should.not.exist(error)
          _.isArray(responseData).should.eql.true
          responseData.should.have.length(4)
          responseData.should.include('this')
          responseData.should.include('is')
          responseData.should.include('a')
          responseData.should.include('test')
          done()
      )

      req.end("this is a test")

    it 'should get a successful response without any WordFrequencyAnalyzer options defined', (done) ->
      options = 
        port: PORT,
        hostname: 'localhost',
        method: 'POST',
        path: '/analyzeDocument?desiredWordListByFrequencyLength=3'

      req = http.request(options, (response) ->
        readStream response, true, (error, responseData) ->
          should.not.exist(error)
          _.isArray(responseData).should.eql.true
          responseData.should.have.length(3)
          responseData.should.include('this')
          responseData.should.include('is')
          responseData.should.include('a')
          done()
      )

      req.end("this is a test")

    it 'should get a successful response with one WordFrequencyAnalyzer options overridden', (done) ->
      options = 
        port: PORT,
        hostname: 'localhost',
        method: 'POST',
        path: '/analyzeDocument?desiredWordListByFrequencyLength=5'
        headers: {
          'options': JSON.stringify({ caseSensitivityEnabled: true })
        }

      req = http.request(options, (response) ->
        readStream response, true, (error, responseData) ->
          should.not.exist(error)
          _.isArray(responseData).should.eql.true
          responseData.should.have.length(5)
          responseData.should.include('This')
          responseData.should.include('is')
          responseData.should.include('a')
          responseData.should.include('Andrew\'s')
          responseData.should.include('test')
          done()
      )

      req.end("This is a Andrew's test")

    it 'should get a successful response with all WordFrequencyAnalyzer options defined', (done) ->
      options = 
        port: PORT,
        hostname: 'localhost',
        method: 'POST',
        path: '/analyzeDocument?desiredWordListByFrequencyLength=4'
        headers: {
          'options': JSON.stringify({ caseSensitivityEnabled: true, filterStopWords: true, extractFullRootWord: true })
        }

      req = http.request(options, (response) ->
        readStream response, true, (error, responseData) ->
          should.not.exist(error)
          _.isArray(responseData).should.eql.true
          responseData.should.have.length(3)
          responseData.should.include('This')
          responseData.should.include('test')
          responseData.should.include('Andrew')
          done()
      )

      req.end("This is a Andrew's test")
