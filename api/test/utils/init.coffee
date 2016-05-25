app = require '../../src/server'
fixtures = require '../utils/fixtures'

server = null

before (done) ->
  server = app.listen(done)

after (done) ->
  server.close(done)

beforeEach ->
    fixtures.loadAll(app)

afterEach ->
  fixtures.deleteAll(app)

module.exports = app
