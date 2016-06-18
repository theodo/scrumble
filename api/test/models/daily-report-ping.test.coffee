expect = require('chai').expect
request = require 'request'
fixtures = require '../utils/fixtures'
app = require '../../src/server'

describe 'api/DailyReportPing endpoint', ->

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

    it 'should set time', (done) ->

      request
        headers:
          Authorization: 'chuckDefinesHisOwnTokens'
        uri: "#{app.get('url')}v1/DailyReportPings"
        method: 'POST'
        json: true
        body:
          name: 'test'
      , (err, response, body) ->
        expect(body.name).to.eql 'test'
        expect(Date.parse(body.createdAt)).not.to.be.NaN
        done()
