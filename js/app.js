'use strict';
var app;

app = angular.module('NotSoShitty', ['ng', 'ngResource', 'ngAnimate', 'ngMaterial', 'ui.router', 'app.templates', 'Parse', 'LocalStorageModule', 'satellizer', 'trello-api-client', 'NotSoShitty.login', 'NotSoShitty.settings', 'NotSoShitty.storage', 'NotSoShitty.bdc', 'NotSoShitty.daily-report']);

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

angular.module('NotSoShitty.daily-report', []);

angular.module('NotSoShitty.login', []);

angular.module('NotSoShitty.settings', []);

angular.module('NotSoShitty.storage', []);

angular.module('NotSoShitty.bdc').config(function($stateProvider) {
  return $stateProvider.state('burn-down-chart-main', {
    url: '/burn-down-chart',
    templateUrl: 'burn-down-chart/states/main/view.html'
  }).state('burn-down-chart', {
    url: '/burn-down-chart',
    controller: 'BurnDownChartCtrl',
    templateUrl: 'burn-down-chart/states/bdc/view.html'
  }).state('burn-down-table', {
    url: '/burn-down-table',
    controller: 'BDCTableCtrl',
    templateUrl: 'burn-down-chart/states/table/view.html'
  });
});

angular.module('NotSoShitty.bdc').factory('BDCDataProvider', function() {
  var generateData, getCardPoints, getDoneBetweenDays, hideFuture;
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
  getDoneBetweenDays = function(doneCards, start, end, lastDay, dailyHour) {
    var card, donePoints, endDate, startDate, _i, _len;
    if (!end) {
      return;
    }
    if (dailyHour == null) {
      dailyHour = 10;
    }
    if (lastDay) {
      endDate = moment();
    } else {
      endDate = moment(end.date);
    }
    endDate.add(1, 'days').hour(dailyHour);
    if (start != null) {
      startDate = moment(start.date).add(1, 'days').hour(dailyHour);
    }
    donePoints = 0;
    for (_i = 0, _len = doneCards.length; _i < _len; _i++) {
      card = doneCards[_i];
      if (card.movedDate) {
        if (moment(card.movedDate).isBefore(endDate)) {
          if (startDate) {
            if (moment(card.movedDate).isAfter(startDate)) {
              donePoints += getCardPoints(card);
            }
          } else if (!start) {
            donePoints += getCardPoints(card);
          }
        }
      }
    }
    return donePoints;
  };
  hideFuture = function(value, day, today) {
    if (isNaN(value)) {
      return;
    }
    if (moment(today).isBefore(moment(day.date).add(1, 'days'))) {
      return;
    }
    return value;
  };
  generateData = function(cards, days, resources, dayPlusOne, dailyHour) {
    var data, day, diff, donePoints, doneToday, i, ideal, manDays, previousDay, today, _i, _len;
    if (!(cards && days && resources)) {
      return;
    }
    data = [];
    ideal = resources.speed * resources.totalManDays;
    doneToday = 0;
    diff = 0;
    today = Date().toString();
    if (dayPlusOne) {
      today = moment(today).add(1, 'days').toString();
    }
    data.push({
      day: 'Start',
      standard: ideal,
      done: 0,
      left: ideal,
      diff: 0
    });
    previousDay = void 0;
    for (i = _i = 0, _len = days.length; _i < _len; i = ++_i) {
      day = days[i];
      manDays = _.reduce(resources.matrix[i], function(s, n) {
        return s + n;
      });
      donePoints = getDoneBetweenDays(cards, days[i - 1], day, i >= days.length - 1, dailyHour);
      ideal = ideal - resources.speed * manDays;
      doneToday += donePoints;
      diff = ideal - (resources.totalPoints - doneToday);
      data.push({
        day: day.label,
        done: donePoints,
        manDays: manDays,
        standard: ideal,
        left: hideFuture(resources.totalPoints - doneToday, day, today),
        diff: hideFuture(diff, day, today)
      });
      previousDay = day;
    }
    return data;
  };
  return {
    generateData: generateData,
    getCardPoints: getCardPoints
  };
});

angular.module('NotSoShitty.daily-report').config(function($stateProvider) {
  return $stateProvider.state('daily-report', {
    url: '/daily-report',
    templateUrl: 'daily-report/states/view.html'
  });
});

angular.module('NotSoShitty.daily-report').controller('DailyReportCtrl', function($scope) {});

angular.module('NotSoShitty.login').config(function($stateProvider) {
  return $stateProvider.state('login', {
    url: '/login',
    controller: 'LoginCtrl',
    templateUrl: 'login/states/login/view.html'
  });
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
            console.log(settings);
            return settings;
          });
        });
      },
      boards: function(TrelloClient) {
        return TrelloClient.get('/members/me/boards').then(function(response) {
          return response.data;
        });
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

    UserBoard.configure("UserBoard", "token", "boardId");

    return UserBoard;

  })(Parse.Model);
});

angular.module('NotSoShitty.storage').service('SettingsStorage', function(Settings) {
  return {
    get: function(boardId) {
      if (boardId == null) {
        return null;
      }
      return Settings.query({
        where: {
          boardId: boardId
        }
      }).then(function(settingsArray) {
        if (settingsArray.length > 0) {
          return settingsArray[0];
        } else {
          return null;
        }
      });
    }
  };
});

angular.module('NotSoShitty.storage').service('UserBoardStorage', function(UserBoard, localStorageService) {
  return {
    getBoardId: function() {
      var token;
      token = localStorageService.get('trello_token');
      if (token == null) {
        return null;
      }
      return UserBoard.query({
        where: {
          token: token
        }
      }).then(function(userBoards) {
        if (userBoards.length > 0) {
          return userBoards[0].boardId;
        } else {
          return null;
        }
      });
    },
    setBoardId: function(boardId) {
      var token, userBoard;
      token = localStorageService.get('trello_token');
      if (token == null) {
        return null;
      }
      userBoard = new UserBoard();
      userBoard.token = token;
      userBoard.boardId = boardId;
      return userBoard.save();
    }
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
      var bdcgraph, computeDimensions, config, maxWidth, render, whRatio;
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
          width: width,
          height: height,
          margins: {
            top: 20,
            right: 70,
            bottom: 20,
            left: 50
          },
          tickSize: 5,
          color: {
            standard: '#D93F8E',
            done: '#5AA6CB'
          }
        };
        return config;
      };
      config = computeDimensions();
      bdcgraph = d3.select('#bdcgraph');
      window.onresize = function() {
        config = computeDimensions();
        return render(scope.data, config);
      };
      render = function(data, cfg) {
        var drawDoneLine, drawStandardLine, drawValues, drawZero, vis, xAxis, xRange, yAxis, yRange;
        bdcgraph.select('*').remove();
        vis = bdcgraph.append('svg').attr('width', cfg.width).attr('height', cfg.height);
        xRange = d3.scale.linear().range([cfg.margins.left, cfg.width - cfg.margins.right]).domain([
          d3.min(data, function(d, i) {
            return i + 1;
          }), d3.max(data, function(d, i) {
            return i + 1;
          })
        ]);
        yRange = d3.scale.linear().range([cfg.height - cfg.margins.bottom, cfg.margins.top]).domain([
          d3.min(data, function(d, i) {
            if (d.left) {
              return (Math.min(d.standard, d.left)) - 1;
            } else {
              return d.standard - 1;
            }
          }), d3.max(data, function(d, i) {
            return d.standard + 4;
          })
        ]);
        xAxis = d3.svg.axis().scale(xRange).tickSize(0).ticks(data.length).tickFormat(function(d) {
          return data[d - 1].day;
        });
        yAxis = d3.svg.axis().scale(yRange).tickSize(0).orient('left').tickSubdivide(true).tickFormat(function(d) {
          return d;
        });
        vis.append('svg:g').attr('class', 'x axis').attr('transform', 'translate(0,' + (yRange(0)) + ')').attr('fill', '#000000').call(xAxis);
        vis.append('svg:g').attr('class', 'y axis').attr('transform', 'translate(' + cfg.margins.left + ',0)').attr('fill', '#000000').call(yAxis);
        d3.selectAll('.tick text').attr('font-size', '16px');
        drawZero = d3.svg.line().x(function(d, i) {
          return xRange(i + 1);
        }).y(function(d) {
          return yRange(0);
        }).interpolate('linear');
        vis.append('svg:path').attr('class', 'axis').attr('d', drawZero(data)).attr('stroke', cfg.color.done).attr('stroke-width', 1).attr('fill', 'none');
        drawStandardLine = function(color) {
          var drawStandard, standardArray;
          standardArray = _.filter(data, function(d) {
            return d.standard != null;
          });
          standardArray = _.map(standardArray, function(d) {
            return d.standard;
          });
          drawStandard = d3.svg.line().x(function(d, i) {
            return xRange(i + 1);
          }).y(function(d) {
            return yRange(d);
          }).interpolate('linear');
          vis.append('svg:path').attr('class', 'standard').attr('d', drawStandard(standardArray)).attr('stroke', color).attr('stroke-width', 2).attr('fill', 'none');
          return vis.selectAll('circle .standard-point').data(data).enter().append('circle').attr('class', 'standard-point').attr('cx', function(d, i) {
            return xRange(i + 1);
          }).attr('cy', function(d) {
            return yRange(d.standard);
          }).attr('r', 4).attr('fill', cfg.color.standard);
        };
        drawDoneLine = function(color) {
          var drawLine, values, valuesArray;
          values = _.filter(data, function(d) {
            return d.left != null;
          });
          valuesArray = _.map(values, function(d) {
            return d.left;
          });
          drawLine = d3.svg.line().x(function(d, i) {
            return xRange(i + 1);
          }).y(function(d) {
            return yRange(d);
          }).interpolate('linear');
          vis.append('svg:path').attr('class', 'done-line').attr('d', drawLine(valuesArray)).attr('stroke', color).attr('stroke-width', 2).attr('fill', 'none');
          return vis.selectAll('circle .done-point').data(values).enter().append('circle').attr('class', 'done-point').attr('cx', function(d, i) {
            return xRange(i + 1);
          }).attr('cy', function(d) {
            if (d.left == null) {
              return;
            }
            return yRange(d.left);
          }).attr('r', 4).attr('fill', cfg.color.done);
        };
        drawValues = function(color) {
          var values;
          values = _.filter(data, function(d) {
            return (d.left != null) && (d.standard != null) && (d.diff != null);
          });
          return vis.selectAll('text .done-values').data(values).enter().append('text').attr('class', 'done-values').attr('font-size', '16px').attr('class', function(d) {
            if (d.diff >= 0) {
              return 'good done-values';
            } else {
              return 'bad done-values';
            }
          }).attr('x', function(d, i) {
            return xRange(i + 1);
          }).attr('y', function(d) {
            return -10 + yRange(Math.max(d.standard, d.left));
          }).attr('fill', cfg.color.done).attr('text-anchor', 'start').text(function(d) {
            if (d.diff >= 0) {
              return '+' + d.diff.toPrecision(2) + ' :)';
            } else {
              return d.diff.toPrecision(2) + ' :(';
            }
          });
        };
        drawStandardLine(cfg.color.standard);
        drawDoneLine(cfg.color.done);
        return drawValues();
      };
      return scope.$watch('data', function(data) {
        if (!data) {
          return;
        }
        return render(data, config);
      });
    }
  };
});

angular.module('NotSoShitty.bdc').controller('BurnDownChartCtrl', function($scope, BDCDataProvider) {});



angular.module('NotSoShitty.login').controller('LoginCtrl', function($scope, TrelloClient, $state, $auth) {
  if ($auth.isAuthenticated()) {
    $state.go('settings');
  }
  return $scope.login = function() {
    return TrelloClient.authenticate().then(function() {
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
        team.push(key);
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
        _results.push($scope.teamCheck[member] = true);
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

angular.module('NotSoShitty.settings').factory('Avatar', function(TrelloClient) {
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

angular.module('NotSoShitty.settings').controller('TrelloAvatarCtrl', function(Avatar, $scope) {
  if (!$scope.size) {
    $scope.size = '50';
  }
  return $scope.$watch('memberId', function(memberId) {
    if (!memberId) {
      return;
    }
    return Avatar.getMember($scope.memberId).then(function(member) {
      return $scope.member = member;
    });
  });
});

angular.module('NotSoShitty.settings').directive('trelloAvatar', function() {
  return {
    restrict: 'E',
    templateUrl: 'settings/directives/trello-avatar/view.html',
    scope: {
      memberId: '@',
      size: '@'
    },
    controller: 'TrelloAvatarCtrl'
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
    return TrelloClient.get('/boards/' + next + '/members').then(function(response) {
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
