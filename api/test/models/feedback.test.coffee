_ = require 'lodash'
expect = require('chai').expect
sinon = require 'sinon'
request = require 'request'
fixtures = require '../utils/fixtures'
logger = require '../../src/logger'

describe 'api/Feedback endpoint', ->
  app = require '../utils/init'


  describe.only 'POST /', ->

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

    it 'send an email', (done) ->
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
        done()
    return
