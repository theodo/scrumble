_ = require 'lodash'
expect = require('chai').expect
request = require 'request'
fixtures = require '../utils/fixtures'
app = require '../../src/server'
sinon = require 'sinon'

describe 'api/Sprint endpoint', ->

  server = null

  before (done) ->
    server = app.listen(done)

  after (done) ->
    server.close(done)

  beforeEach ->
      fixtures.loadAll(app)

  afterEach ->
    fixtures.deleteAll(app)

  describe 'GET /:boardGroupId/problems', ->

    it 'should return a list of all problems of projects the user has access on Trello', (done) ->
      sinon.stub(request, 'get')
      # stub request.get only when called with these arguments
      .withArgs({
        url: sinon.match(/^.+api.trello.com.+/)
        json: true
      }, sinon.match.func)
      # call the callback (wich is the second argument) with the given values
      .callsArgWith(1, null, {}, [{id: "ok1"}, {id: "ok2"}, {id: "ok3"}])

      boardGroup =
        username: 'chuck_noris'
        boards: ["ok1", "ok2", "unauthorizedByTrello"]
        name: 'A group'

      fixtures.loadGroup(app, boardGroup)
      .then (group) ->
        request
          headers:
            Authorization: 'chuckDefinesHisOwnTokens'
          uri: "#{app.get('url')}v1/BoardGroups/#{group.id}/problems"
          method: 'GET'
          json: true
        , (err, response, body) ->
          expect(response.body.length).to.eql(2)
          expect(response.statusCode).to.eql(200)
          request.get.restore()
          done()
      .catch done
      return
