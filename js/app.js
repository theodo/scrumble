'use strict';
var app;

app = angular.module('NotSoShitty', ['ng', 'ngResource', 'ngAnimate', 'ngMaterial', 'md.data.table', 'ui.router', 'app.templates', 'Parse', 'LocalStorageModule', 'satellizer', 'permission', 'trello-api-client', 'NotSoShitty.login', 'NotSoShitty.settings', 'NotSoShitty.storage', 'NotSoShitty.bdc', 'NotSoShitty.common', 'NotSoShitty.daily-report']);

app.config(function($locationProvider, $urlRouterProvider, ParseProvider) {
  $locationProvider.hashPrefix('!');
  $urlRouterProvider.otherwise('/login');
  return ParseProvider.initialize("UTkdR7MH2Wok5lyPEm1VHoxyFKWVcdOKAu6A4BWG", "DGp8edP1LHPJ15GpDE3cp94bBaDq2hiMSqLEzfZB");
});

app.config(function(localStorageServiceProvider) {
  return localStorageServiceProvider.setPrefix('');
});

app.config(function(TrelloClientProvider) {
  return TrelloClientProvider.init({
    key: '2dcb2ba290c521d2b5c2fd69cc06830e',
    appName: 'Not So Shitty',
    tokenExpiration: 'never',
    scope: ['read', 'write', 'account']
  });
});

app.config(function($mdThemingProvider) {
  $mdThemingProvider.theme('default').primaryPalette('blue').accentPalette('grey');
});

app.run(function($rootScope, $state) {
  return $rootScope.$state = $state;
});

angular.module('NotSoShitty.bdc', []);

angular.module('NotSoShitty.common', []);

angular.module('NotSoShitty.daily-report', []);

angular.module('NotSoShitty.login', []);

angular.module('NotSoShitty.settings', ['NotSoShitty.common']);

angular.module('NotSoShitty.storage', []);

angular.module('NotSoShitty.bdc').config(function($stateProvider) {
  return $stateProvider.state('burn-down-chart', {
    url: '/burn-down-chart',
    controller: 'BurnDownChartCtrl',
    templateUrl: 'burn-down-chart/states/bdc/view.html',
    resolve: {
      settings: function(UserBoardStorage, SettingsStorage) {
        return UserBoardStorage.getBoardId().then(function(boardId) {
          return SettingsStorage.get(boardId);
        })["catch"](function(err) {
          return null;
        });
      },
      doneCards: function(UserBoardStorage, SettingsStorage, TrelloClient) {
        return UserBoardStorage.getBoardId().then(function(boardId) {
          return SettingsStorage.get(boardId);
        }).then(function(response) {
          return response.data;
        }).then(function(settings) {
          return TrelloClient.get('/lists/' + settings.columnIds.done + '/cards?fields=name');
        }).then(function(response) {
          return response.data;
        })["catch"](function(err) {
          return null;
        });
      }
    }
  });
});

angular.module('NotSoShitty.bdc').factory('BDCDataProvider', function() {
  var getCardPoints, getDonePoints, initializeBDC;
  getCardPoints = function(card) {
    var match, matchVal, value, _i, _len;
    if (!card.name) {
      return;
    }
    match = card.name.match(/\(([-+]?[0-9]*\.?[0-9]+)\)/);
    value = 0;
    if (match) {
      for (_i = 0, _len = match.length; _i < _len; _i++) {
        matchVal = match[_i];
        if (!isNaN(parseFloat(matchVal, 10))) {
          value = parseFloat(matchVal, 10);
        }
      }
    }
    return value;
  };
  getDonePoints = function(doneCards) {
    return _.sum(doneCards, getCardPoints);
  };
  initializeBDC = function(days, resources) {
    var bdc, day, i, standard, _i, _len;
    standard = 0;
    bdc = [];
    for (i = _i = 0, _len = days.length; _i < _len; i = ++_i) {
      day = days[i];
      bdc.push({
        date: moment(day.date).toDate(),
        standard: standard,
        done: null
      });
      standard += _.sum(resources.matrix[i]) * resources.speed;
    }
    bdc.push({
      date: moment(day.date).add(1, 'days').toDate(),
      standard: standard,
      done: null
    });
    return bdc;
  };
  return {
    getCardPoints: getCardPoints,
    initializeBDC: initializeBDC,
    getDonePoints: getDonePoints
  };
});

angular.module('NotSoShitty.daily-report').config(function($stateProvider) {
  return $stateProvider.state('daily-report', {
    url: '/daily-report',
    templateUrl: 'daily-report/states/view.html'
  });
});

angular.module('NotSoShitty.daily-report').controller('DailyReportCtrl', function($scope) {});

angular.module('NotSoShitty.login').run(function(Permission, $auth, $q) {
  return Permission.defineRole('trello-authenticated', function() {
    return $auth.isAuthenticated();
  });
});

angular.module('NotSoShitty.login').config(function($stateProvider) {
  return $stateProvider.state('login', {
    url: '/login',
    controller: 'LoginCtrl',
    templateUrl: 'login/states/login/view.html'
  });
});

angular.module('NotSoShitty.login').service('User', function($auth, TrelloClient) {
  return {
    getTrelloInfo: function() {
      return TrelloClient.get('/member/me').then(function(response) {
        return response.data;
      });
    }
  };
});

angular.module('NotSoShitty.settings').config(function($stateProvider) {
  return $stateProvider.state('settings', {
    url: '/settings',
    controller: 'SettingsCtrl',
    templateUrl: 'settings/states/main/view.html',
    resolve: {
      settings: function(UserBoardStorage, SettingsStorage) {
        return UserBoardStorage.getBoardId().then(function(boardId) {
          if (boardId == null) {
            return null;
          }
          return SettingsStorage.get(boardId).then(function(settings) {
            return settings;
          });
        });
      },
      boards: function(TrelloClient) {
        return TrelloClient.get('/members/me/boards').then(function(response) {
          return response.data;
        });
      }
    },
    data: {
      permissions: {
        only: ['trello-authenticated'],
        redirectTo: 'login'
      }
    }
  });
});

angular.module('NotSoShitty.settings').service('Computer', function() {
  var calculateSpeed, calculateTotalPoints, generateResources, getTotalManDays;
  getTotalManDays = function(matrix) {
    var cell, line, total, _i, _j, _len, _len1;
    total = 0;
    for (_i = 0, _len = matrix.length; _i < _len; _i++) {
      line = matrix[_i];
      for (_j = 0, _len1 = line.length; _j < _len1; _j++) {
        cell = line[_j];
        total += cell;
      }
    }
    return total;
  };
  calculateTotalPoints = function(totalManDays, speed) {
    return totalManDays * speed;
  };
  calculateSpeed = function(totalPoints, totalManDays) {
    if (!(totalManDays > 0)) {
      return;
    }
    return totalPoints / totalManDays;
  };
  generateResources = function(days, devTeam) {
    var day, line, matrix, member, _i, _j, _len, _len1;
    if (!(days && devTeam)) {
      return;
    }
    matrix = [];
    for (_i = 0, _len = days.length; _i < _len; _i++) {
      day = days[_i];
      line = [];
      for (_j = 0, _len1 = devTeam.length; _j < _len1; _j++) {
        member = devTeam[_j];
        line.push(1);
      }
      matrix.push(line);
    }
    return matrix;
  };
  return {
    generateResources: generateResources,
    calculateSpeed: calculateSpeed,
    calculateTotalPoints: calculateTotalPoints,
    getTotalManDays: getTotalManDays
  };
});

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

angular.module('NotSoShitty.storage').factory('Settings', function(Parse) {
  var Settings;
  return Settings = (function(_super) {
    __extends(Settings, _super);

    function Settings() {
      return Settings.__super__.constructor.apply(this, arguments);
    }

    Settings.configure("Settings", "data", "boardId");

    return Settings;

  })(Parse.Model);
});

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

angular.module('NotSoShitty.storage').factory('UserBoard', function(Parse) {
  var UserBoard;
  return UserBoard = (function(_super) {
    __extends(UserBoard, _super);

    function UserBoard() {
      return UserBoard.__super__.constructor.apply(this, arguments);
    }

    UserBoard.configure("UserBoard", "email", "boardId");

    return UserBoard;

  })(Parse.Model);
});

angular.module('NotSoShitty.storage').service('SettingsStorage', function(Settings, $q) {
  return {
    get: function(boardId) {
      var deferred;
      deferred = $q.defer();
      if (boardId != null) {
        Settings.query({
          where: {
            boardId: boardId
          }
        }).then(function(settingsArray) {
          var settings;
          settings = settingsArray.length > 0 ? settingsArray[0] : null;
          return deferred.resolve(settings);
        })["catch"](deferred.reject);
      } else {
        deferred.reject('No boardId');
      }
      return deferred.promise;
    }
  };
});

angular.module('NotSoShitty.storage').service('UserBoardStorage', function(UserBoard, User, localStorageService) {
  var getBoardId, setBoardId;
  getBoardId = function() {
    var token;
    token = localStorageService.get('trello_token');
    if (token == null) {
      return null;
    }
    return User.getTrelloInfo().then(function(userInfo) {
      return UserBoard.query({
        where: {
          email: userInfo.email
        }
      });
    }).then(function(userBoards) {
      if (userBoards.length > 0) {
        return userBoards[0].boardId;
      } else {
        return null;
      }
    });
  };
  setBoardId = function(boardId) {
    var token;
    token = localStorageService.get('trello_token');
    if (token == null) {
      return null;
    }
    return User.getTrelloInfo().then(function(userInfo) {
      return UserBoard.query({
        where: {
          email: userInfo.email
        }
      }).then(function(userBoards) {
        var board, userBoard;
        board = userBoards.length > 0 ? userBoards[0] : null;
        if (board != null) {
          board.boardId = boardId;
          return board.save();
        } else {
          userBoard = new UserBoard();
          userBoard.email = userInfo.email;
          userBoard.boardId = boardId;
          return userBoard.save();
        }
      });
    });
  };
  return {
    getBoardId: getBoardId,
    setBoardId: setBoardId
  };
});

angular.module('NotSoShitty.bdc').directive('burndown', function() {
  return {
    restrict: 'AE',
    scope: {
      data: '='
    },
    templateUrl: 'burn-down-chart/directives/burndown/view.html',
    link: function(scope, elem, attr) {
      var computeDimensions, config, maxWidth, whRatio;
      maxWidth = 1000;
      whRatio = 0.54;
      computeDimensions = function() {
        var config, height, width;
        if (window.innerWidth > maxWidth) {
          width = 800;
        } else {
          width = window.innerWidth - 80;
        }
        height = whRatio * width;
        if (height + 128 > window.innerHeight) {
          height = window.innerHeight - 128;
          width = height / whRatio;
        }
        config = {
          containerId: '#bdcgraph',
          width: width,
          height: height,
          margins: {
            top: 20,
            right: 70,
            bottom: 30,
            left: 50
          },
          colors: {
            standard: '#D93F8E',
            done: '#5AA6CB',
            good: '#97D17A',
            bad: '#FA6E69',
            labels: '#113F59'
          },
          startLabel: 'Start',
          endLabel: 'End',
          dateFormat: '%A',
          xTitle: 'Daily meetings',
          dotRadius: 4,
          standardStrokeWidth: 2,
          doneStrokeWidth: 2,
          goodSuffix: ' :)',
          badSuffix: ' :('
        };
        return config;
      };
      config = computeDimensions();
      window.onresize = function() {
        config = computeDimensions();
        return renderBDC(scope.data, config);
      };
      return scope.$watch('data', function(data) {
        if (!data) {
          return;
        }
        return renderBDC(data, config);
      }, true);
    }
  };
});

angular.module('NotSoShitty.bdc').controller('BurnDownChartCtrl', function($scope, BDCDataProvider, settings, doneCards) {
  var day, getCurrentDayIndex, _i, _len, _ref;
  if (settings.data.bdc != null) {
    _ref = settings.data.bdc;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      day = _ref[_i];
      day.date = moment(day.date).toDate();
    }
  } else {
    settings.data.bdc = BDCDataProvider.initializeBDC(settings.data.dates.days, settings.data.resources);
  }
  $scope.tableData = settings.data.bdc;
  getCurrentDayIndex = function(bdcData) {
    var i, _j, _len1;
    for (i = _j = 0, _len1 = bdcData.length; _j < _len1; i = ++_j) {
      day = bdcData[i];
      if (day.done == null) {
        return i;
      }
    }
  };
  $scope.currentDayIndex = getCurrentDayIndex($scope.tableData);
  $scope.goToNextDay = function() {
    if ($scope.tableData[$scope.currentDayIndex].done == null) {
      return;
    }
    return settings.save().then(function() {
      if ($scope.currentDayIndex >= $scope.tableData.length) {
        return;
      }
      return $scope.currentDayIndex += 1;
    });
  };
  $scope.fetchTrelloDonePoints = function() {
    return $scope.tableData[$scope.currentDayIndex].done = BDCDataProvider.getDonePoints(doneCards);
  };
});

angular.module('NotSoShitty.common').directive('nssRound', function() {
  return {
    require: 'ngModel',
    link: function(scope, element, attrs, ngModelController) {
      ngModelController.$parsers.push(function(data) {
        return parseFloat(data);
      });
      ngModelController.$formatters.push(function(data) {
        if (_.isNumber(data)) {
          data = data.toFixed(1);
        }
        return data;
      });
    }
  };
});

angular.module('NotSoShitty.common').factory('Avatar', function(TrelloClient) {
  return {
    getMember: function(memberId) {
      if (!memberId) {
        return;
      }
      return TrelloClient.get('/members/' + memberId).then(function(response) {
        var hash;
        if (response.data.uploadedAvatarHash) {
          hash = response.data.uploadedAvatarHash;
        } else if (response.data.avatarHash) {
          hash = response.data.avatarHash;
        } else {
          hash = null;
        }
        return {
          username: response.data.username,
          fullname: response.data.fullname,
          hash: hash,
          initials: response.data.initials
        };
      });
    }
  };
});

angular.module('NotSoShitty.common').controller('TrelloAvatarCtrl', function(Avatar, $scope) {
  if (!$scope.size) {
    $scope.size = '50';
  }
  return $scope.$watch('member', function(member) {
    if (member == null) {
      return $scope.hash = null;
    }
    if (member.uploadedAvatarHash) {
      return $scope.hash = member.uploadedAvatarHash;
    } else if (member.avatarHash) {
      return $scope.hash = member.avatarHash;
    } else {
      return $scope.hash = null;
    }
  });
});

angular.module('NotSoShitty.common').directive('trelloAvatar', function() {
  return {
    restrict: 'E',
    templateUrl: 'common/directives/trello-avatar/view.html',
    scope: {
      size: '@',
      member: '='
    },
    controller: 'TrelloAvatarCtrl'
  };
});

angular.module('NotSoShitty.login').controller('ProfilInfoCtrl', function($rootScope, $scope, $auth, User, $state) {
  var getTrelloInfo;
  $scope.logout = function() {
    $auth.logout();
    $scope.userInfo = null;
    $state.go('login');
    return $scope.showProfilCard = false;
  };
  getTrelloInfo = function() {
    if ($auth.isAuthenticated()) {
      return User.getTrelloInfo().then(function(info) {
        return $scope.userInfo = info;
      });
    }
  };
  getTrelloInfo();
  $rootScope.$on('refresh-profil', getTrelloInfo);
  $scope.showProfilCard = false;
  return $scope.toggleProfilCard = function() {
    return $scope.showProfilCard = !$scope.showProfilCard;
  };
});

angular.module('NotSoShitty.login').directive('profilInfo', function() {
  return {
    restrict: 'E',
    templateUrl: 'login/directives/profil-info/view.html',
    scope: {},
    controller: 'ProfilInfoCtrl'
  };
});

angular.module('NotSoShitty.login').controller('LoginCtrl', function($scope, $rootScope, TrelloClient, $state, $auth) {
  if ($auth.isAuthenticated()) {
    $state.go('settings');
  }
  return $scope.login = function() {
    return TrelloClient.authenticate().then(function() {
      $rootScope.$broadcast('refresh-profil');
      return $state.go('settings');
    });
  };
});

angular.module('NotSoShitty.settings').controller('ResourcesByDayCtrl', function($scope) {
  var changeResource;
  changeResource = function(dayIndex, memberIndex, matrix) {
    matrix[dayIndex][memberIndex] += 0.5;
    if (matrix[dayIndex][memberIndex] > 1) {
      matrix[dayIndex][memberIndex] = 0;
    }
    return matrix;
  };
  return $scope.resourceClick = function(i, j) {
    return $scope.matrix = angular.copy(changeResource(i, j, $scope.matrix));
  };
});

angular.module('NotSoShitty.settings').directive('resourcesByDay', function() {
  return {
    restrict: 'E',
    templateUrl: 'settings/directives/resources-by-day/view.html',
    scope: {
      members: '=',
      matrix: '=',
      days: '='
    },
    controller: 'ResourcesByDayCtrl'
  };
});

angular.module('NotSoShitty.settings').controller('ResourcesWidgetCtrl', function($scope, Computer) {
  var generateDayList, _ref, _ref1, _ref2, _ref3;
  if ((_ref = $scope.dates) != null) {
    _ref.start = moment((_ref1 = $scope.dates) != null ? _ref1.start : void 0).toDate();
  }
  if ((_ref2 = $scope.dates) != null) {
    _ref2.end = moment((_ref3 = $scope.dates) != null ? _ref3.end : void 0).toDate();
  }
  $scope.clearTeam = function() {
    $scope.team.rest = [];
    return $scope.team.dev = [];
  };
  generateDayList = function(start, end) {
    var current, day, days, endM;
    if (!(start && end)) {
      return;
    }
    current = moment(start);
    endM = moment(end).add(1, 'days');
    if (!endM.isAfter(current)) {
      return;
    }
    days = [];
    while (!current.isSame(endM)) {
      day = current.isoWeekday();
      if (day !== 6 && day !== 7) {
        days.push({
          label: current.format('dddd'),
          date: current.format()
        });
      }
      current.add(1, 'days');
    }
    return days;
  };
  $scope.$watch('dates.end', function(newVal, oldVal) {
    if (newVal === oldVal) {
      return;
    }
    if (newVal == null) {
      return;
    }
    return $scope.dates.days = generateDayList($scope.dates.start, $scope.dates.end);
  });
  $scope.$watch('dates.days', function(newVal, oldVal) {
    var _ref4, _ref5;
    if (newVal === oldVal) {
      return;
    }
    return $scope.resources.matrix = Computer.generateResources((_ref4 = $scope.dates) != null ? _ref4.days : void 0, (_ref5 = $scope.team) != null ? _ref5.dev : void 0);
  });
  $scope.$watch('team.dev', function(newVal, oldVal) {
    var _ref4, _ref5;
    if (newVal === oldVal) {
      return;
    }
    return $scope.resources.matrix = Computer.generateResources((_ref4 = $scope.dates) != null ? _ref4.days : void 0, (_ref5 = $scope.team) != null ? _ref5.dev : void 0);
  });
  $scope.$watch('resources.matrix', function(newVal, oldVal) {
    if (newVal === oldVal) {
      return;
    }
    if (!newVal) {
      return;
    }
    return $scope.resources.totalManDays = Computer.getTotalManDays(newVal);
  });
  $scope.$watch('resources.totalManDays', function(newVal, oldVal) {
    if (newVal === oldVal) {
      return;
    }
    if (!(newVal && newVal > 0)) {
      return;
    }
    return $scope.resources.speed = Computer.calculateSpeed($scope.resources.totalPoints, newVal);
  });
  $scope.$watch('resources.totalPoints', function(newVal, oldVal) {
    if (newVal === oldVal) {
      return;
    }
    if (!(newVal && newVal > 0)) {
      return;
    }
    return $scope.resources.speed = Computer.calculateSpeed(newVal, $scope.resources.totalManDays);
  });
  return $scope.$watch('resources.speed', function(newVal, oldVal) {
    if (newVal === oldVal) {
      return;
    }
    if (!(newVal && newVal > 0)) {
      return;
    }
    return $scope.resources.totalPoints = Computer.calculateTotalPoints($scope.resources.totalManDays, newVal);
  });
});

angular.module('NotSoShitty.settings').directive('resourcesWidget', function() {
  return {
    restrict: 'E',
    templateUrl: 'settings/directives/resources-widget/view.html',
    scope: {
      boardMembers: '=',
      team: '=',
      dates: '=',
      resources: '='
    },
    controller: 'ResourcesWidgetCtrl'
  };
});

angular.module('NotSoShitty.settings').controller('SelectBoardCtrl', function() {});

angular.module('NotSoShitty.settings').directive('selectBoard', function() {
  return {
    restrict: 'E',
    templateUrl: 'settings/directives/select-board/view.html',
    scope: {
      boards: '=',
      boardId: '='
    },
    controller: 'SelectBoardCtrl'
  };
});

angular.module('NotSoShitty.settings').controller('SelectColumnsCtrl', function($scope) {
  $scope.listTypes = ['backlog', 'sprintBacklog', 'doing', 'blocked', 'toValidate', 'done'].reverse();
  return $scope.columnIds != null ? $scope.columnIds : $scope.columnIds = {};
});

angular.module('NotSoShitty.settings').directive('selectColumns', function() {
  return {
    restrict: 'E',
    templateUrl: 'settings/directives/select-columns/view.html',
    scope: {
      boardColumns: '=',
      columnIds: '='
    },
    controller: 'SelectColumnsCtrl'
  };
});

angular.module('NotSoShitty.settings').controller('SelectPeopleCtrl', function($scope) {
  if ($scope.teamCheck == null) {
    $scope.teamCheck = {};
  }
  $scope.check = function() {
    var checked, key, team, _ref;
    team = [];
    _ref = $scope.teamCheck;
    for (key in _ref) {
      checked = _ref[key];
      if (checked) {
        team.push(_.find($scope.members, function(member) {
          return member.id === key;
        }));
      }
    }
    return $scope.selectedMembers = team;
  };
  return $scope.$watch('selectedMembers', function(newVal) {
    var member, _i, _len, _ref, _results;
    if (!newVal) {
      return;
    }
    if (newVal.length > 0) {
      if ($scope.teamCheck == null) {
        $scope.teamCheck = {};
      }
      _ref = $scope.selectedMembers;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        member = _ref[_i];
        _results.push($scope.teamCheck[member.id] = true);
      }
      return _results;
    } else {
      return $scope.teamCheck = {};
    }
  });
});

angular.module('NotSoShitty.settings').directive('selectPeople', function() {
  return {
    restrict: 'E',
    templateUrl: 'settings/directives/select-people/view.html',
    scope: {
      members: '=',
      selectedMembers: '='
    },
    controller: 'SelectPeopleCtrl'
  };
});

angular.module('NotSoShitty.settings').controller('SettingsCtrl', function($scope, boards, TrelloClient, localStorageService, UserBoardStorage, $mdToast, Settings, settings) {
  var _base;
  $scope.boards = boards;
  if (settings == null) {
    settings = new Settings();
    settings.data = {};
  }
  $scope.settings = settings.data;
  if ((_base = $scope.settings).resources == null) {
    _base.resources = {};
  }
  $scope.$watch('settings.boardId', function(next, prev) {
    if (!next) {
      return;
    }
    UserBoardStorage.setBoardId(next);
    TrelloClient.get('/boards/' + next + '/lists').then(function(response) {
      return $scope.boardColumns = response.data;
    });
    return TrelloClient.get('/boards/' + next + '/members?fields=avatarHash,fullName,initials,username').then(function(response) {
      return $scope.boardMembers = response.data;
    });
  });
  $scope.save = function() {
    var saveFeedback;
    if ($scope.settings.boardId == null) {
      return;
    }
    settings.boardId = $scope.settings.boardId;
    saveFeedback = $mdToast.simple().hideDelay(1000).position('top right').content('Saved!');
    return settings.save().then(function() {
      return $mdToast.show(saveFeedback);
    });
  };
});
