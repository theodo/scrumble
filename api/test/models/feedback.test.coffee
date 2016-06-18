_ = require 'lodash'
expect = require('chai').expect
sinon = require 'sinon'
request = require 'request'
logger = require '../../src/logger'
fixtures = require '../utils/fixtures'
app = require '../../src/server'

describe 'api/Feedback endpoint', ->

  server = null

  before (done) ->
    server = app.listen(done)

  after (done) ->
    server.close(done)

  beforeEach ->
      fixtures.loadAll(app)

  afterEach ->
    fixtures.deleteAll(app)

  describe 'POST /', ->

    it 'should set time and reporter', (done) ->

      request
        headers:
          Authorization: 'chuckDefinesHisOwnTokens'
        uri: "#{app.get('url')}v1/Feedbacks"
        method: 'POST'
        json: true
        body:
          message: 'test'
      , (err, response, body) ->
        expect(body.reporter).to.eql 'noris@gmail.com'
        expect(Date.parse(body.createdAt)).not.to.be.NaN
        done()

    it 'should send an email', (done) ->
      sinon.spy(logger, 'email')
      request
        headers:
          Authorization: 'chuckDefinesHisOwnTokens'
        uri: "#{app.get('url')}v1/Feedbacks"
        method: 'POST'
        json: true
        body:
          message: 'test'
      , (err, response, body) ->
        expect(logger.email.called).to.be.true
        expect(Date.parse(body.createdAt)).not.to.be.NaN
        done()
    return
