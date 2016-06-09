loopbackApiTesting = require './utils/loopback-api-testing'
fixtures = require './utils/fixtures'
app = require '../src/server'
url = "http://#{process.env.HOST}:#{process.env.PORT}"

tests = [
  method: "GET"
  model: "Sprints"
  expect: 401
,
  method: "GET"
  model: "Sprints"
  token: "chuckDefinesHisOwnTokens"
  expect: 200
,
  method: "GET"
  model: "Sprints/active"
  expect: 401
,
  method: "GET"
  model: "Sprints/active"
  token: "chuckDefinesHisOwnTokens"
  expect: 200

  method: "GET"
  model: "Organizations"
  expect: 401
,
  method: "GET"
  model: "Organizations"
  token: "chuckDefinesHisOwnTokens"
  expect: 200
,
  method: "POST"
  model: "Organizations"
  expect: 401
,
  method: "POST"
  model: "Organizations"
  token: "chuckDefinesHisOwnTokens"
  expect: 401
]

describe 'Status codes', ->
  beforeEach = ->
    fixtures.loadAll(app)

  afterEach = ->
    fixtures.deleteAll(app)

  loopbackApiTesting.run tests, app, url, beforeEach, afterEach, (err) ->
    console.error err if err?
