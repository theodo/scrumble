_ = require 'lodash'
expect = require('chai').expect
request = require 'request'
fixtures = require '../utils/fixtures'

describe 'api/Sprint endpoint', ->
  app = require '../utils/init'

  describe 'GET /active', ->

    it 'should return null if user has no project set', (done) ->
      user =
        email: 'noris-junior@gmail.com'
        remoteId: '12345'
        password: 'dummy'
        accessTokens: ['chuckJuniorDefinesHisOwnTokens']
        projectId: null

      fixtures.loadUser(app, user).then ->
        request
          headers:
            Authorization: user.accessTokens[0]
          uri: "#{app.get('url')}api/Sprints/active"
          method: 'GET'
          json: true
        , (err, response, body) ->
          expect(body).to.eql(null)
          done()
      .catch done
      return

    tests = [
      activeSprint: null
    ,
      activeSprint: 2
    ]
    tests.forEach (test) ->
      it 'should return the user project active sprint', (done) ->
        project =
          name: 'Scrumble'
          boardId: 'trello-id-scrumble'
          objectId: 'a'
          sprints: [
            isActive: test.activeSprint is 1
            number: 1
            objectId: 'a'
          ,
            isActive: test.activeSprint is 2
            number: 2
            objectId: 'a'
          ]
        fixtures.loadProject(app, project).then (projectId) ->
          user =
            email: 'noris-junior@gmail.com'
            remoteId: '12345'
            password: 'dummy'
            accessTokens: ['chuckJuniorDefinesHisOwnTokens']
            projectId: projectId

          fixtures.loadUser(app, user).then ->
            request
              headers:
                Authorization: user.accessTokens[0]
              uri: "#{app.get('url')}api/Sprints/active"
              method: 'GET'
              json: true
            , (err, response, body) ->
              if test.activeSprint?
                expect(body).to.not.eql(null)
                expect(body.number).to.eql(test.activeSprint)
              else
                expect(body).to.eql(null)
              done()
        .catch done
        return
