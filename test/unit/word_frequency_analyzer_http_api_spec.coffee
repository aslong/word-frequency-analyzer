debug  = require('debug')('test:wfa:WordFrequencyAnalyzer:http_api_spec')
ERRORS = require('../../src/constants/word_frequency_analyzer/errors')
http   = require('http')
server = require('../../src/index')
should = require('should')
_      = require('underscore')

PORT = 8000

readResponse = (response, cb) ->
  data = ""
  response.on 'data', (chunk) ->
    data += chunk
  response.on 'end', () ->
    cb(null, JSON.parse(data))
  response.on 'error', (e) ->
    cb(e)

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

  describe 'resonse test', () ->
    it 'should get a response', (done) ->
      options = 
        port: PORT,
        hostname: 'localhost',
        method: 'POST',
        path: '/analyzeDocument?desiredWordListByFrequencyLength=3'

      req = http.request(options, (res) ->
        readResponse res, (error, responseData) ->
          should.not.exist(error)
          _.isArray(responseData).should.eql.true
          responseData.should.have.length(3)
          responseData.should.include('this')
          responseData.should.include('is')
          responseData.should.include('a')
          done()
      )

      req.end("this is a test")
