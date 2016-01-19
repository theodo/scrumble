describe 'dynamicFields', ->
  beforeEach module 'Scrumble.login'

  beforeEach inject (
    $state
    $auth
    $http
    $q
    $injector
    $rootScope
    localStorageService
    googleAuth
  ) ->
    @$state = $state
    @$rootScope = $rootScope
    @$auth = $auth
    @$http = $http
    @localStorageService = localStorageService
    @googleAuth = googleAuth
    @$q = $q
    @$httpBackend = $injector.get '$httpBackend'
    @localStorageService.set 'trello_token', 'abc'

  afterEach ->
    @localStorageService.clearAll()

  describe 'getAuthorizationHeader', ->
    it 'should return what is in the local storage', ->
      @localStorageService.set 'google_token', 'abc'
      header = @googleAuth.getAuthorizationHeader()
      expect(header).toEqual 'Bearer abc'

    it 'should return null if the local storage is not set', ->
      header = @googleAuth.getAuthorizationHeader()
      expect(header).toEqual null

  describe 'getUserInfo', ->
    it 'should reject if bad credentials', ->
      @$httpBackend.when('GET', 'https://content.googleapis.com/oauth2/v2/userinfo')
      .respond(401)

      result = null
      @googleAuth.getUserInfo()
      .catch ->
        result = 'ko'

      @$httpBackend.flush()
      expect(result).toEqual 'ko'

    it 'should resolve user data', ->
      userInfo = {
        email: "toto@theodo.fr",
        name: "Nicolas Girault",
        picture: "toto.jpg",
      }
      @$httpBackend.when('GET', 'https://content.googleapis.com/oauth2/v2/userinfo')
      .respond(200, userInfo)

      result = null
      @googleAuth.getUserInfo().then (userInfo) ->
        result = userInfo

      @$httpBackend.flush()
      expect(result).toEqual userInfo

    it 'should use cache if available', ->
      userInfo = 'yolo'
      @$httpBackend.expectGET('https://content.googleapis.com/oauth2/v2/userinfo')
      .respond(200, userInfo)

      result = null
      @googleAuth.getUserInfo().then (userInfo) ->
        result = userInfo

      @$httpBackend.flush()

      # if data is in cache (after first call), it wont call $http so
      # httpBackend.flush will throw an error
      @googleAuth.getUserInfo().then (userInfo) ->
        result = userInfo
      expect(@$httpBackend.flush).toThrowError 'No pending request to flush !'

  describe 'logout', ->
    it 'should clean the local storage', ->
      @localStorageService.set 'google_token', 'abc'
      @googleAuth.logout()
      token = @localStorageService.get 'google_token'
      expect(token).toEqual null

  describe 'isAuthenticated', ->
    it 'should return false if no data in local storage', ->
      isAuthenticated = null
      @googleAuth.isAuthenticated().then (response) ->
        isAuthenticated = response

      @$rootScope.$digest()
      expect(isAuthenticated).toEqual false

    it 'should return false if google API returns 401', ->
      isAuthenticated = null

      @localStorageService.set 'google_token', 'abc'
      @$httpBackend.when('GET', 'https://content.googleapis.com/oauth2/v2/userinfo')
      .respond(401)

      @googleAuth.isAuthenticated().then (response) ->
        isAuthenticated = response

      @$httpBackend.flush()
      expect(isAuthenticated).toEqual false

    it 'should return true if google API returns 200', ->
      isAuthenticated = null

      @localStorageService.set 'google_token', 'abc'
      @$httpBackend.when('GET', 'https://content.googleapis.com/oauth2/v2/userinfo')
      .respond(200)

      @googleAuth.isAuthenticated().then (response) ->
        isAuthenticated = response

      @$httpBackend.flush()
      expect(isAuthenticated).toEqual true

  describe 'login', ->
    it 'should set local storage', ->
      spyOn(@$auth, 'authenticate').and.returnValue(then: (callback) -> callback({access_token: 'toto'}))
      @googleAuth.login()

      @$rootScope.$digest()
      expect(@$auth.authenticate).toHaveBeenCalledWith 'google'
      token = @localStorageService.get 'google_token'
      expect(token).toEqual 'toto'
