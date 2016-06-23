describe 'ClientFormCtrl', ->
  beforeEach module 'Scrumble.indicators'

  $q = null
  $controller = null
  $rootScope = null
  GAuth = null
  GApi = null
  loadingToast = null
  Sprint = null

  beforeEach inject (_$q_, _$controller_, _$rootScope_, _GAuth_, _GApi_, _Sprint_, _loadingToast_) ->
    $q = _$q_
    $controller = _$controller_
    $rootScope = _$rootScope_
    GAuth = _GAuth_
    Sprint = _Sprint_
    loadingToast = _loadingToast_
    GApi = _GApi_

  describe 'google authentification', ->
    it 'should update scope when connected', ->
      spyOn(GAuth, 'checkAuth').and.returnValue $q.when []
      $scope = $rootScope.$new()
      controller = $controller 'ClientFormCtrl',
        $scope: $scope
        GAuth: GAuth
      $scope.googleCheckAuthentified()
      $scope.$digest()
      expect($scope.googleAuthentified).toBe true
      expect($scope.googleAuthentifying).toBe false

    it 'should update scope when not connected', ->
      spyOn(GAuth, 'checkAuth').and.returnValue $q.reject []
      $scope = $rootScope.$new()
      controller = $controller 'ClientFormCtrl',
        $scope: $scope
        GAuth: GAuth
      $scope.googleCheckAuthentified()
      $scope.$digest()
      expect($scope.googleAuthentified).toBe false
      expect($scope.googleAuthentifying).toBe false

  describe 'spreadsheet api', ->
    it 'should write a "hello world" in a google sheet', ->
      spyOn(GApi, 'executeAuth').and.returnValue $q.when []
      $scope = $rootScope.$new()
      controller = $controller 'ClientFormCtrl',
        $scope: $scope
        GAuth: GAuth
        GApi: GApi
      $scope.helloWorldInSpreadsheet()
      $scope.$digest()
      queryParams = {
        spreadsheetId: '1qeRBk1TMi9zoaQUz9Zqlasb_w0w2_ehcYk5zApdzefU'
        range: 'Sheet1!A1:A1'
        majorDimension: 'ROWS'
        valueInputOption: 'RAW'
        values: [['Bonjour le monde']]
      }
      expect(GApi.executeAuth).toHaveBeenCalledWith('sheets', 'spreadsheets.values.update', queryParams)
      expect($scope.savingInSpreadsheet).toBe false
