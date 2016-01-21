'use strict';
var app;

app = angular.module('Scrumble', ['ng', 'ngResource', 'ngAnimate', 'ngSanitize', 'ngMaterial', 'md.data.table', 'ui.router', 'app.templates', 'Parse', 'LocalStorageModule', 'satellizer', 'permission', 'trello-api-client', 'Scrumble.sprint', 'Scrumble.common', 'Scrumble.daily-report', 'Scrumble.gmail-client', 'Scrumble.feedback', 'Scrumble.login', 'Scrumble.settings', 'Scrumble.storage', 'Scrumble.board', 'Scrumble.indicators']);

app.config(function($locationProvider, $urlRouterProvider, ParseProvider) {
  $locationProvider.hashPrefix('!');
  $urlRouterProvider.otherwise('/');
  return ParseProvider.initialize("UTkdR7MH2Wok5lyPEm1VHoxyFKWVcdOKAu6A4BWG", "DGp8edP1LHPJ15GpDE3cp94bBaDq2hiMSqLEzfZB");
});

app.config(function(localStorageServiceProvider) {
  return localStorageServiceProvider.setPrefix('');
});

app.config(function(TrelloClientProvider) {
  return TrelloClientProvider.init({
    key: '2dcb2ba290c521d2b5c2fd69cc06830e',
    appName: 'Scrumble',
    tokenExpiration: 'never',
    scope: ['read', 'account']
  });
});

app.config(function($mdIconProvider) {
  return $mdIconProvider.defaultIconSet('icons/mdi.light.svg');
});

app.run(function($rootScope, $state) {
  return $rootScope.$state = $state;
});

angular.module('Scrumble.board', ['ui.router', 'ngMaterial']);

angular.module('Scrumble.common', ['trello-api-client', 'ngMaterial', 'ui.router']);

angular.module('Scrumble.daily-report', ['trello-api-client', 'ui.router']);

angular.module('Scrumble.feedback', []);

angular.module('Scrumble.gmail-client', []);

angular.module('Scrumble.indicators', []);

angular.module('Scrumble.login', ['LocalStorageModule', 'satellizer', 'ui.router', 'permission', 'trello-api-client']);

angular.module('Scrumble.settings', ['Scrumble.common']);

angular.module('Scrumble.sprint', ['ui.router', 'Parse', 'ngMaterial']);

angular.module('Scrumble.storage', []);

angular.module('Scrumble.board').config(function($stateProvider) {
  return $stateProvider.state('tab.board', {
    url: '/',
    controller: 'BoardCtrl',
    templateUrl: 'board/states/board/view.html',
    resolve: {
      checkProjectAndSprint: function(project, sprint, $state) {
        if (project == null) {
          return $state.go('tab.project');
        }
        if (sprint == null) {
          return $state.go('tab.new-sprint');
        }
      }
    },
    onEnter: function(sprint, $state) {
      var day, _i, _len, _ref, _results;
      if (sprint.bdcData != null) {
        _ref = sprint.bdcData;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          day = _ref[_i];
          _results.push(day.date = moment(day.date).toDate());
        }
        return _results;
      }
    }
  });
});

angular.module('Scrumble.common').run(function($rootScope, $state, $window) {
  var finish;
  finish = function() {
    return $window.loading_screen.finish();
  };
  $rootScope.$on('$stateChangeSuccess', finish);
  $rootScope.$on('$stateChangeError', finish);
  return $rootScope.$on('$stateNotFound', finish);
});

angular.module('Scrumble.common').config(function($stateProvider) {
  return $stateProvider.state('tab', {
    abstract: true,
    templateUrl: 'common/states/base.html',
    controller: 'BaseCtrl',
    resolve: {
      sprint: function(ScrumbleUser, Sprint) {
        return ScrumbleUser.getCurrentUser().then(function(user) {
          if ((user != null ? user.project : void 0) == null) {
            return null;
          }
          return Sprint.getActiveSprint(user.project);
        }).then(function(sprint) {
          if (sprint == null) {
            return null;
          }
          return sprint;
        });
      },
      project: function(ScrumbleUser, Project) {
        return ScrumbleUser.getCurrentUser().then(function(user) {
          if ((user != null ? user.project : void 0) == null) {
            return null;
          }
          return Project.find(user.project.objectId);
        });
      }
    }
  });
});

angular.module('Scrumble.common').config(function($mdThemingProvider) {
  var customAccent, customBackground, customPrimary, customWarn;
  customPrimary = {
    '50': '#4b91e8',
    '100': '#3483e6',
    '200': '#1e75e3',
    '300': '#1a69cd',
    '400': '#175eb7',
    '500': '#1452A0',
    '600': '#114689',
    '700': '#0e3b73',
    '800': '#0c2f5c',
    '900': '#092445',
    'A100': '#629feb',
    'A200': '#78adee',
    'A400': '#8fbaf1',
    'A700': '#06182f',
    'contrastDefaultColor': 'light'
  };
  $mdThemingProvider.definePalette('customPrimary', customPrimary);
  customAccent = {
    '50': '#c2e5d8',
    '100': '#b0ddcd',
    '200': '#9ed5c1',
    '300': '#8dcdb6',
    '400': '#7bc6aa',
    '500': '#69be9f',
    '600': '#57b694',
    '700': '#4aaa87',
    '800': '#429879',
    '900': '#3a876b',
    'A100': '#d4ece3',
    'A200': '#e6f4ef',
    'A400': '#f7fcfa',
    'A700': '#33755d',
    'contrastDefaultColor': 'light'
  };
  $mdThemingProvider.definePalette('customAccent', customAccent);
  customWarn = {
    '50': '#f8c2c1',
    '100': '#f5abaa',
    '200': '#f39593',
    '300': '#f07e7c',
    '400': '#ee6865',
    '500': '#EB514E',
    '600': '#e83a37',
    '700': '#e62420',
    '800': '#d41c18',
    '900': '#be1915',
    'A100': '#fbd8d7',
    'A200': '#fdefee',
    'A400': '#ffffff',
    'A700': '#a71613',
    'contrastDefaultColor': 'light'
  };
  $mdThemingProvider.definePalette('customWarn', customWarn);
  customBackground = {
    '50': '#ffffff',
    '100': '#ffffff',
    '200': '#ffffff',
    '300': '#ffffff',
    '400': '#fcfcfc',
    '500': '#EFEFEF',
    '600': '#e2e2e2',
    '700': '#d5d5d5',
    '800': '#c9c9c9',
    '900': '#bcbcbc',
    'A100': '#ffffff',
    'A200': '#ffffff',
    'A400': '#ffffff',
    'A700': '#afafaf'
  };
  $mdThemingProvider.definePalette('customBackground', customBackground);
  return $mdThemingProvider.theme('default').primaryPalette('customPrimary', {
    'default': '300',
    'hue-2': '100'
  }).accentPalette('customAccent', {
    'default': '700',
    'hue-2': '900'
  }).warnPalette('customWarn', {
    'default': '500'
  }).backgroundPalette('customBackground');
});

angular.module('Scrumble.common').controller('ModalCtrl', function($scope, $mdDialog) {
  $scope.hide = function() {
    return $mdDialog.hide();
  };
  $scope.cancel = function() {
    return $mdDialog.cancel();
  };
  return $scope.save = function(response) {
    return $mdDialog.hide(response);
  };
});

angular.module('Scrumble.common').service('nssModal', function($mdDialog, $mdMedia) {
  return {
    show: function(options) {
      var useFullScreen;
      useFullScreen = $mdMedia('sm') || $mdMedia('xs');
      return $mdDialog.show({
        controller: options.controller,
        templateUrl: options.templateUrl,
        targetEvent: options.targetEvent,
        resolve: options.resolve,
        parent: angular.element(document.body),
        clickOutsideToClose: true,
        fullscreen: useFullScreen
      });
    }
  };
});

angular.module('Scrumble.common').service('dynamicFields', function($q, trelloUtils) {
  var dict, getCurrentDayIndex, project, replaceToday, replaceYesterday, sprint;
  sprint = null;
  project = null;
  getCurrentDayIndex = function(bdcData) {
    var day, i, _i, _len;
    for (i = _i = 0, _len = bdcData.length; _i < _len; i = ++_i) {
      day = bdcData[i];
      if (day.done == null) {
        return Math.max(i - 1, 0);
      }
    }
    return i - 1;
  };
  dict = {
    '{sprintNumber}': {
      value: function() {
        return sprint != null ? sprint.number : void 0;
      },
      description: 'Current sprint number',
      icon: 'cow'
    },
    '{sprintGoal}': {
      value: function() {
        return sprint != null ? sprint.goal : void 0;
      },
      description: 'The sprint goal (never forget it)',
      icon: 'target'
    },
    '{speed}': {
      value: function() {
        var _ref, _ref1, _ref2;
        if (_.isNumber(sprint != null ? (_ref = sprint.resources) != null ? _ref.speed : void 0 : void 0)) {
          return sprint != null ? (_ref1 = sprint.resources) != null ? _ref1.speed.toFixed(1) : void 0 : void 0;
        } else {
          return sprint != null ? (_ref2 = sprint.resources) != null ? _ref2.speed : void 0 : void 0;
        }
      },
      description: 'Estimated number of points per day per person',
      icon: 'run'
    },
    '{toValidate}': {
      value: function() {
        var _ref;
        if ((project != null ? (_ref = project.columnMapping) != null ? _ref.toValidate : void 0 : void 0) != null) {
          return trelloUtils.getColumnPoints(project.columnMapping.toValidate);
        }
      },
      description: 'The number of points in the Trello to validate column',
      icon: 'phone'
    },
    '{blocked}': {
      value: function() {
        var _ref;
        if ((project != null ? (_ref = project.columnMapping) != null ? _ref.blocked : void 0 : void 0) != null) {
          return trelloUtils.getColumnPoints(project.columnMapping.blocked);
        }
      },
      description: 'The number of points in the Trello blocked column',
      icon: 'radioactive'
    },
    '{done}': {
      value: function() {
        var done, index, _ref;
        if ((sprint != null ? sprint.bdcData : void 0) != null) {
          index = getCurrentDayIndex(sprint.bdcData);
          done = (_ref = sprint.bdcData[index]) != null ? _ref.done : void 0;
          if (_.isNumber(done)) {
            return done.toFixed(1);
          } else {
            return done;
          }
        }
      },
      description: 'The number of points in the Trello done column',
      icon: 'check'
    },
    '{gap}': {
      value: function() {
        var diff, index, _ref, _ref1;
        if ((sprint != null ? sprint.bdcData : void 0) != null) {
          index = getCurrentDayIndex(sprint.bdcData);
          diff = ((_ref = sprint.bdcData[index]) != null ? _ref.done : void 0) - ((_ref1 = sprint.bdcData[index]) != null ? _ref1.standard : void 0);
          return Math.abs(diff).toFixed(1);
        }
      },
      description: 'The difference between the standard points and the done points',
      icon: 'tshirt-crew'
    },
    '{total}': {
      value: function() {
        var _ref;
        if (_.isNumber(sprint != null ? (_ref = sprint.resources) != null ? _ref.totalPoints : void 0 : void 0)) {
          return sprint.resources.totalPoints.toFixed(1);
        }
      },
      description: 'The number of points to finish the sprint',
      icon: 'cart'
    }
  };
  replaceToday = function(text) {
    return text.replace(/\{today#(.+?)\}/g, function(match, dateFormat) {
      return moment().format(dateFormat);
    });
  };
  replaceYesterday = function(text) {
    return text.replace(/\{yesterday#(.+?)\}/g, function(match, dateFormat) {
      return moment().subtract(1, 'days').format(dateFormat);
    });
  };
  return {
    sprint: function(_sprint_) {
      return sprint = _sprint_;
    },
    project: function(_project_) {
      return project = _project_;
    },
    getAvailableFields: function() {
      var result;
      result = _.map(dict, function(value, key) {
        return {
          key: key,
          description: value.description,
          icon: value.icon
        };
      });
      result.push({
        key: '{today#format}',
        description: 'Today\'s date where format is a <a href="http://momentjs.com/docs/#/parsing/string-format/" target="_blank">moment format</a>',
        icon: 'clock'
      });
      result.push({
        key: '{yesterday#format}',
        description: 'Yesterday\'s date where format is a <a href="http://momentjs.com/docs/#/parsing/string-format/" target="_blank">moment format</a>. examples: EEEE for weekday, YYYY-MM-DD',
        icon: 'calendar-today'
      });
      return result;
    },
    render: function(text) {
      var deferred, elt, key, promises, result;
      result = text || '';
      deferred = $q.defer();
      promises = {};
      for (key in dict) {
        elt = dict[key];
        promises[key] = elt.value();
      }
      $q.all(promises).then(function(builtDict) {
        for (key in builtDict) {
          elt = builtDict[key];
          result = result.split(key).join(elt);
        }
        result = replaceToday(result);
        result = replaceYesterday(result);
        return deferred.resolve(result);
      })["catch"](deferred.reject);
      return deferred.promise;
    }
  };
});

angular.module('Scrumble.common').service('loadingToast', function($mdToast) {
  var toast;
  toast = $mdToast.build({
    templateUrl: 'common/views/loading-toast.html',
    position: 'top left'
  });
  return {
    show: function() {
      return $mdToast.show(toast);
    },
    hide: function() {
      return $mdToast.hide(toast);
    }
  };
});

angular.module('Scrumble.common').service('trelloUtils', function(TrelloClient) {
  var getCardPoints;
  getCardPoints = function(card) {
    var match, matchVal, value, _i, _len;
    if (!_.isString(card != null ? card.name : void 0)) {
      return 0;
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
  return {
    getColumnPoints: function(columnId) {
      return TrelloClient.get('/lists/' + columnId + '/cards?fields=name').then(function(response) {
        var cards;
        cards = response.data;
        return _.sum(cards, getCardPoints);
      })["catch"](function(err) {
        console.warn(err);
        return 0;
      });
    }
  };
});

angular.module('Scrumble.common').controller('BaseCtrl', function($scope, $mdSidenav, $state, Sprint, Project, sprint, project) {
  var _ref, _ref1, _ref2;
  $scope.project = project;
  $scope.sprint = sprint;
  $scope.toggleSidenav = function() {
    return $mdSidenav('left').toggle();
  };
  $scope.goTo = function(item) {
    $state.go(item.state, item.params);
    return $mdSidenav('left').close();
  };
  $scope.$on('project:update', function(event, data) {
    return $state.reload('tab').then(function() {
      if ((data != null ? data.nextState : void 0) != null) {
        return $state.go(data.nextState);
      }
    });
  });
  $scope.$on('sprint:update', function(event, data) {
    return $state.reload('tab').then(function() {
      if ((data != null ? data.nextState : void 0) != null) {
        return $state.go(data.nextState);
      }
    });
  });
  return $scope.menu = [
    {
      title: 'Project',
      items: [
        {
          state: 'tab.new-sprint',
          title: 'Start New Sprint',
          icon: 'plus'
        }, {
          state: 'tab.sprint-list',
          params: {
            projectId: (_ref = $scope.project) != null ? _ref.objectId : void 0
          },
          title: 'Sprints',
          icon: 'view-list'
        }, {
          state: 'tab.project',
          title: 'Settings',
          icon: 'settings'
        }
      ]
    }, {
      title: 'Current Sprint',
      items: [
        {
          state: 'tab.board',
          title: 'Burndown Chart',
          icon: 'trending-down'
        }, {
          state: 'tab.indicators',
          params: {
            sprintId: (_ref1 = $scope.sprint) != null ? _ref1.objectId : void 0
          },
          title: 'Indicators',
          icon: 'chart-bar'
        }, {
          state: 'tab.edit-sprint',
          params: {
            sprintId: (_ref2 = $scope.sprint) != null ? _ref2.objectId : void 0
          },
          title: 'Settings',
          icon: 'settings'
        }
      ]
    }, {
      title: 'Daily Mail',
      items: [
        {
          state: 'tab.daily-report',
          title: 'Write Today\'s Daily',
          icon: 'gmail'
        }, {
          state: 'tab.edit-template',
          title: 'Edit Template',
          icon: 'code-braces'
        }
      ]
    }
  ];
});

angular.module('Scrumble.daily-report').config(function($stateProvider) {
  return $stateProvider.state('tab.edit-template', {
    url: '/daily-report/edit',
    templateUrl: 'daily-report/states/edit-template/view.html',
    controller: 'EditTemplateCtrl',
    resolve: {
      dailyReport: function(ScrumbleUser, DailyReport, Project) {
        return ScrumbleUser.getCurrentUser().then(function(user) {
          return DailyReport.getByProject(user.project).then(function(report) {
            if (report != null) {
              return report;
            }
            report = new DailyReport({
              project: new Project(user.project),
              message: {
                subject: '[MyProject] Sprint #{sprintNumber} - Daily Mail {today#YYYY-MM-DD}',
                body: 'Hello Batman,\n\n' + 'here is the daily mail:\n\n' + '- Done: {done} / {total} points\n' + '- To validate: {toValidate} points\n' + '- Blocked: {blocked} points\n' + '- {behind/ahead}: {gap} points {color=smart}\n\n' + '{bdc}\n\n' + 'Yesterday\'s goals:\n' + '- Eat carrots {color=green}\n\n' + 'Today\'s goals\n' + '- Eat more carrots\n\n' + 'Regards!',
                behindLabel: 'Behind',
                aheadLabel: 'Ahead'
              }
            });
            return report.save();
          });
        });
      }
    }
  }).state('tab.daily-report', {
    url: '/daily-report',
    templateUrl: 'daily-report/states/template/view.html',
    controller: 'DailyReportCtrl',
    resolve: {
      dailyReport: function(ScrumbleUser, DailyReport, Project) {
        return ScrumbleUser.getCurrentUser().then(function(user) {
          return DailyReport.getByProject(user.project).then(function(report) {
            if (report != null) {
              return report;
            }
            report = new DailyReport({
              project: new Project(user.project),
              message: {
                subject: '[MyProject] Sprint #{sprintNumber} - Daily Mail {today#YYYY-MM-DD}',
                body: 'Hello Batman,\n\n' + 'here is the daily mail:\n\n' + '- Done: {done} / {total} points\n' + '- To validate: {toValidate} points\n' + '- Blocked: {blocked} points\n' + '- {behind/ahead}: {gap} points {color=smart}\n\n' + '{bdc}\n\n' + 'Yesterday\'s goals:\n' + '- Eat carrots {color=green}\n\n' + 'Today\'s goals\n' + '- Eat more carrots\n\n' + 'Regards!',
                behindLabel: 'Behind',
                aheadLabel: 'Ahead'
              }
            });
            return report.save();
          });
        });
      },
      sprint: function(ScrumbleUser, Sprint) {
        return ScrumbleUser.getCurrentUser().then(function(user) {
          return Sprint.getActiveSprint(user.project);
        })["catch"](function(err) {
          console.log(err);
          return null;
        });
      },
      project: function(ScrumbleUser) {
        return ScrumbleUser.getCurrentUser().then(function(user) {
          return user.project;
        });
      }
    }
  });
});

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

angular.module('Scrumble.daily-report').factory('DailyReport', function(Parse) {
  var DailyReport;
  return DailyReport = (function(_super) {
    __extends(DailyReport, _super);

    function DailyReport() {
      return DailyReport.__super__.constructor.apply(this, arguments);
    }

    DailyReport.configure("DailyReport", "project", "message", "metadata");

    DailyReport.getByProject = function(project) {
      return this.query({
        where: {
          project: {
            __type: "Pointer",
            className: "Project",
            objectId: project.objectId
          }
        }
      }).then(function(response) {
        if (response.length > 0) {
          return response[0];
        } else {
          return null;
        }
      });
    };

    return DailyReport;

  })(Parse.Model);
});

angular.module('Scrumble.daily-report').service('trelloCards', function($q, TrelloClient) {
  return {
    getTodoCards: function(project, sprint) {
      var promises, _ref, _ref1, _ref2, _ref3;
      promises = [];
      if ((project != null ? (_ref = project.columnMapping) != null ? _ref.blocked : void 0 : void 0) != null) {
        promises.push(TrelloClient.get("/lists/" + project.columnMapping.blocked + "/cards"));
      }
      if ((project != null ? (_ref1 = project.columnMapping) != null ? _ref1.toValidate : void 0 : void 0) != null) {
        promises.push(TrelloClient.get("/lists/" + project.columnMapping.toValidate + "/cards"));
      }
      if ((project != null ? (_ref2 = project.columnMapping) != null ? _ref2.doing : void 0 : void 0) != null) {
        promises.push(TrelloClient.get("/lists/" + project.columnMapping.doing + "/cards"));
      }
      if ((sprint != null ? sprint.sprintColumn : void 0) != null) {
        promises.push(TrelloClient.get("/lists/" + sprint.sprintColumn + "/cards"));
      } else if ((project != null ? (_ref3 = project.columnMapping) != null ? _ref3.sprint : void 0 : void 0) != null) {
        promises.push(TrelloClient.get("/lists/" + project.columnMapping.sprint + "/cards"));
      }
      return $q.all(promises).then(function(responses) {
        var response;
        return _.flatten((function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = responses.length; _i < _len; _i++) {
            response = responses[_i];
            _results.push(response.data);
          }
          return _results;
        })());
      });
    },
    getDoneCardIds: function(doneColumnId) {
      var deferred;
      deferred = $q.defer();
      if (doneColumnId != null) {
        TrelloClient.get("/lists/" + doneColumnId + "/cards").then(function(response) {
          var card;
          return deferred.resolve((function() {
            var _i, _len, _ref, _results;
            _ref = response.data;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              card = _ref[_i];
              _results.push(card.id);
            }
            return _results;
          })());
        });
      } else {
        deferred.resolve([]);
      }
      return deferred.promise;
    }
  };
});

angular.module('Scrumble.daily-report').service('reportBuilder', function($q, ScrumbleUser, Sprint, Project, trelloUtils, dynamicFields) {
  var converter, isAhead, project, promise, renderBDC, renderBehindAhead, renderCc, renderColor, renderPreviousGoals, renderSection, renderTo, renderTodaysGoals, sprint;
  converter = new showdown.Converter();
  promise = void 0;
  project = void 0;
  sprint = void 0;
  isAhead = function() {
    var getCurrentDayIndex;
    getCurrentDayIndex = function(bdcData) {
      var day, i, _i, _len;
      for (i = _i = 0, _len = bdcData.length; _i < _len; i = ++_i) {
        day = bdcData[i];
        if (day.done == null) {
          return Math.max(i - 1, 0);
        }
      }
      return i - 1;
    };
    return promise.then(function() {
      var diff, index;
      index = getCurrentDayIndex(sprint.bdcData);
      diff = sprint.bdcData[index].done - sprint.bdcData[index].standard;
      if (diff > 0) {
        return true;
      } else {
        return false;
      }
    });
  };
  renderBehindAhead = function(message) {
    return isAhead().then(function(ahead) {
      var label;
      label = ahead ? message.aheadLabel : message.behindLabel;
      message.body = message.body.replace('{behind/ahead}', label);
      message.subject = message.subject.replace('{behind/ahead}', label);
      return message;
    });
  };
  renderTodaysGoals = function(body, goals) {
    var goal, goalsNames, goalsString;
    if (!_.isArray(goals)) {
      return body;
    }
    goalsNames = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = goals.length; _i < _len; _i++) {
        goal = goals[_i];
        _results.push("- " + goal.name);
      }
      return _results;
    })();
    goalsString = goalsNames.join("\n");
    return body.replace('{todaysGoals}', goalsString);
  };
  renderPreviousGoals = function(body, goals) {
    var color, goal, goalsNames, goalsString, _i, _len;
    if (!_.isArray(goals)) {
      return body;
    }
    goalsNames = [];
    for (_i = 0, _len = goals.length; _i < _len; _i++) {
      goal = goals[_i];
      color = goal.isDone ? 'green' : 'red';
      goalsNames.push("- " + goal.name + (" {color=" + color + "}"));
    }
    goalsString = goalsNames.join("\n");
    return body.replace('{previousGoals}', goalsString);
  };
  renderSection = function(body, key, value) {
    return body.replace("{" + key + "}", value);
  };
  renderColor = function(message) {
    return isAhead().then(function(ahead) {
      message.body = message.body.replace(/>(.*(\{color=(.+?)\}).*)</g, function(match, line, toRemove, color) {
        line = line.replace(toRemove, "");
        if (color === 'smart') {
          color = ahead ? 'green' : 'red';
        }
        return "><span style='color: " + color + ";'>" + line + "</span><";
      });
      return message;
    });
  };
  renderBDC = function(message, bdcBase64, useCid) {
    var src;
    src = useCid ? 'cid:bdc' : bdcBase64;
    return promise.then(function() {
      message.body = message.body.replace('{bdc}', "<img src='" + src + "' />");
      if (useCid) {
        message.cids = [
          {
            type: 'image/png',
            name: 'BDC',
            base64: bdcBase64.split(',')[1],
            id: 'bdc'
          }
        ];
      }
      return message;
    });
  };
  renderTo = function(message) {
    return promise.then(function() {
      var emails, member;
      emails = (function() {
        var _i, _len, _ref, _results;
        _ref = project.team;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          member = _ref[_i];
          if (member.daily === 'to') {
            _results.push(member.email);
          }
        }
        return _results;
      })();
      message.to = _.filter(emails);
      return message;
    });
  };
  renderCc = function(message) {
    return promise.then(function() {
      var emails, member;
      emails = (function() {
        var _i, _len, _ref, _results;
        _ref = project.team;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          member = _ref[_i];
          if (member.daily === 'cc') {
            _results.push(member.email);
          }
        }
        return _results;
      })();
      message.cc = _.filter(emails);
      return message;
    });
  };
  return {
    init: function() {
      return promise = ScrumbleUser.getCurrentUser().then(function(user) {
        project = user.project;
        return project;
      }).then(function(project) {
        return Sprint.getActiveSprint(new Project(project)).then(function(_sprint_) {
          return sprint = _sprint_;
        });
      });
    },
    getAvailableFields: function() {
      return [
        {
          key: '{bdc}',
          description: 'The burndown chart image',
          icon: 'trending-down'
        }, {
          key: '{color=xxx}',
          description: 'This field will color the line on which it is. "xxx" can be any css color. The "smart" color is also recognized: green when the team is ahead or red when the team is late',
          icon: 'format-color-fill'
        }, {
          key: '{behind/ahead}',
          description: 'If your are behind or late according to the burn down chart',
          icon: 'owl'
        }
      ];
    },
    render: function(message, previousGoals, todaysGoals, sections, useCid) {
      var key, value;
      message = angular.copy(message);
      message.body = renderTodaysGoals(message.body, todaysGoals);
      message.body = renderPreviousGoals(message.body, previousGoals);
      for (key in sections) {
        value = sections[key];
        message.body = renderSection(message.body, key, value);
      }
      message.body = converter.makeHtml(message.body);
      dynamicFields.sprint(sprint);
      dynamicFields.project(project);
      return dynamicFields.render(message.subject).then(function(subject) {
        message.subject = subject;
        return dynamicFields.render(message.body);
      }).then(function(body) {
        return message.body = body;
      }).then(function() {
        return renderBehindAhead(message);
      }).then(function() {
        return renderColor(message);
      }).then(function(message) {
        return renderBDC(message, sprint.bdcBase64, useCid);
      }).then(function(message) {
        return renderTo(message);
      }).then(function(message) {
        return renderCc(message);
      });
    }
  };
});

angular.module('Scrumble.feedback').controller('feedbackCallToActionCtrl', function($scope, $mdDialog, $mdMedia) {
  var DialogController;
  $scope.customFullscreen = $mdMedia('sm');
  $scope.openFeedbackModal = function(ev) {
    $mdDialog.show({
      controller: DialogController,
      templateUrl: 'feedback/directives/dialog.html',
      parent: angular.element(document.body),
      targetEvent: ev,
      clickOutsideToClose: true,
      fullscreen: $mdMedia('sm') && $scope.customFullscreen
    }).then((function(answer) {
      $scope.status = 'You said the information was "' + answer + '".';
    }), function() {
      $scope.status = 'You cancelled the dialog.';
    });
    $scope.$watch((function() {
      return $mdMedia('sm');
    }), function(sm) {
      $scope.customFullscreen = sm === true;
    });
  };
  return DialogController = function($scope, $mdDialog, $controller, Feedback, localStorageService) {
    angular.extend(this, $controller('ModalCtrl', {
      $scope: $scope
    }));
    $scope.message = null;
    $scope.doing = false;
    return $scope.send = function() {
      var feedback;
      if ($scope.message != null) {
        $scope.doing = true;
        feedback = new Feedback();
        feedback.reporter = localStorageService.get('trello_email');
        feedback.message = $scope.message;
        return feedback.save().then(function() {
          return $mdDialog.hide();
        });
      }
    };
  };
});

angular.module('Scrumble.feedback').directive('feedback', function() {
  return {
    restrict: 'E',
    templateUrl: 'feedback/directives/call-to-action.html',
    scope: {},
    controller: 'feedbackCallToActionCtrl'
  };
});

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

angular.module('Scrumble.feedback').factory('Feedback', function(Parse) {
  var Feedback;
  return Feedback = (function(_super) {
    __extends(Feedback, _super);

    function Feedback() {
      return Feedback.__super__.constructor.apply(this, arguments);
    }

    Feedback.configure("Feedback", "reporter", "message");

    return Feedback;

  })(Parse.Model);
});

angular.module('Scrumble.gmail-client').constant('SEND_EMAIL_ENDPOINT', 'https://content.googleapis.com/gmail/v1/users/me/messages/send').service('gmailClient', function($http, googleAuth, SEND_EMAIL_ENDPOINT) {
  return {
    send: function(raw) {
      return $http.post(SEND_EMAIL_ENDPOINT, {
        raw: raw
      }, {
        headers: {
          authorization: googleAuth.getAuthorizationHeader()
        },
        params: {
          alt: "json"
        }
      });
    }
  };
});

angular.module('Scrumble.gmail-client').service('mailer', function($state, $rootScope, gmailClient, googleAuth) {
  return {
    send: function(message, callback) {
      if (message.to == null) {
        return callback({
          message: "No 'to' field",
          code: 400
        });
      }
      if (message.subject == null) {
        return callback({
          message: "No 'subject' field",
          code: 400
        });
      }
      if (message.body == null) {
        return callback({
          message: "No 'body' field",
          code: 400
        });
      }
      return googleAuth.getUserInfo().then(function(user) {
        var base64EncodedEmail, originalMail;
        originalMail = {
          to: message.to,
          cc: message.cc,
          subject: message.subject,
          fromName: user.name,
          from: user.email,
          body: message.body,
          cids: message.cids,
          attaches: []
        };
        base64EncodedEmail = btoa(Mime.toMimeTxt(originalMail));
        base64EncodedEmail = base64EncodedEmail.replace(/\+/g, '-').replace(/\//g, '_');
        return gmailClient.send(base64EncodedEmail).then(callback);
      });
    }
  };
});

angular.module('Scrumble.indicators').config(function($stateProvider) {
  return $stateProvider.state('tab.indicators', {
    url: '/sprint/:sprintId/indicators',
    templateUrl: 'indicators/states/base/view.html',
    controller: 'IndicatorsCtrl',
    resolve: {
      currentSprint: function(Sprint, $stateParams) {
        return Sprint.find($stateParams.sprintId);
      }
    }
  });
});

angular.module('Scrumble.login').config(function($authProvider) {
  return $authProvider.google({
    clientId: '605908567890-3bg3dmamghq5gd7i9sqsdhvoflef0qku.apps.googleusercontent.com',
    scope: ['https://www.googleapis.com/auth/userinfo.email', 'https://www.googleapis.com/auth/gmail.send'],
    redirectUri: window.location.origin + window.location.pathname,
    responseType: 'token'
  });
});

angular.module('Scrumble.login').run(function($rootScope, $state, trelloAuth, localStorageService) {
  return $rootScope.$on('$locationChangeSuccess', function() {
    if (!trelloAuth.isLoggedUnsafe()) {
      localStorageService.clearAll();
      return $state.go('trello-login');
    }
  });
});

angular.module('Scrumble.login').config(function($stateProvider) {
  return $stateProvider.state('trello-login', {
    url: '/login/trello',
    controller: 'TrelloLoginCtrl',
    templateUrl: 'login/states/trello/view.html'
  });
});

angular.module('Scrumble.login').service('googleAuth', function($state, $auth, $http, $q, localStorageService) {
  var getAuthorizationHeader, getUserInfo, userInfo;
  userInfo = null;
  getAuthorizationHeader = function() {
    var token;
    token = localStorageService.get('google_token');
    if (token != null) {
      return "Bearer " + token;
    } else {
      return null;
    }
  };
  getUserInfo = function() {
    var deferred;
    deferred = $q.defer();
    if (userInfo != null) {
      deferred.resolve(userInfo);
    } else {
      $http.get('https://content.googleapis.com/oauth2/v2/userinfo', {
        headers: {
          authorization: getAuthorizationHeader()
        }
      }).then(function(response) {
        userInfo = response.data;
        return deferred.resolve(response.data);
      })["catch"](function() {
        return deferred.reject();
      });
    }
    return deferred.promise;
  };
  return {
    logout: function() {
      localStorageService.remove('google_token');
      return userInfo = null;
    },
    login: function() {
      return $auth.authenticate('google').then(function(response) {
        return localStorageService.set('google_token', response.access_token);
      });
    },
    getAuthorizationHeader: getAuthorizationHeader,
    getUserInfo: getUserInfo,
    isAuthenticated: function() {
      var deferred;
      deferred = $q.defer();
      if (localStorageService.get('google_token')) {
        getUserInfo().then(function() {
          return deferred.resolve(true);
        })["catch"](function() {
          return deferred.resolve(false);
        });
      } else {
        deferred.resolve(false);
      }
      return deferred.promise;
    }
  };
});

angular.module('Scrumble.login').service('trelloAuth', function(localStorageService, TrelloClient, $state) {
  return {
    getTrelloInfo: function() {
      return TrelloClient.get('/member/me').then(function(response) {
        return response.data;
      });
    },
    logout: function() {
      localStorageService.remove('trello_email');
      localStorageService.remove('trello_token');
      return $state.go('trello-login');
    },
    isLoggedUnsafe: function() {
      var token;
      token = localStorageService.get('trello_token');
      return token != null;
    }
  };
});

angular.module('Scrumble.settings').config(function($stateProvider) {
  return $stateProvider.state('tab.project', {
    url: '/project',
    controller: 'ProjectCtrl',
    templateUrl: 'project/states/main/view.html',
    resolve: {
      user: function(ScrumbleUser, localStorageService, $state) {
        return ScrumbleUser.getCurrentUser();
      },
      boards: function(TrelloClient) {
        return TrelloClient.get('/members/me/boards').then(function(response) {
          return response.data;
        });
      }
    }
  });
});

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

angular.module('Scrumble.storage').factory('Project', function(Parse, $q) {
  var Project;
  return Project = (function(_super) {
    __extends(Project, _super);

    function Project() {
      return Project.__super__.constructor.apply(this, arguments);
    }

    Project.configure("Project", "boardId", "name", "columnMapping", "team", "currentSprint", "settings");

    Project.get = function(boardId) {
      var deferred;
      deferred = $q.defer();
      if (boardId != null) {
        this.query({
          where: {
            boardId: boardId
          }
        }).then(function(projectsArray) {
          var project;
          project = projectsArray.length > 0 ? projectsArray[0] : null;
          return deferred.resolve(project);
        })["catch"](deferred.reject);
      } else {
        deferred.reject('No boardId');
      }
      return deferred.promise;
    };

    Project.saveTitle = function(project, title) {
      if (project.settings == null) {
        project.settings = {};
      }
      project.settings.bdcTitle = title;
      return project.save().then(function() {
        return title;
      });
    };

    return Project;

  })(Parse.Model);
});

angular.module('Scrumble.settings').service('projectUtils', function($q, ScrumbleUser, Project) {
  var currentProject, roles;
  currentProject = null;
  roles = [
    {
      label: 'Developer',
      value: 'dev'
    }, {
      label: 'Architect Developer',
      value: 'archi'
    }, {
      label: 'Product Owner',
      value: 'PO'
    }, {
      label: 'Scrum Master',
      value: 'SM'
    }, {
      label: 'Stakeholder',
      value: 'stakeholder'
    }, {
      label: 'Commercial',
      value: 'com'
    }
  ];
  return {
    getDailyRecipient: function() {
      return [
        {
          label: 'no',
          value: 'no'
        }, {
          label: 'cc',
          value: 'cc'
        }, {
          label: 'to',
          value: 'to'
        }
      ];
    },
    getRoles: function() {
      return roles;
    },
    getDevTeam: function(team) {
      if (!_.isArray(team)) {
        return [];
      }
      return _.filter(team, function(member) {
        var _ref;
        return (_ref = member != null ? member.role : void 0) === 'dev' || _ref === 'archi';
      });
    },
    getRoleLabel: function(key) {
      var result;
      result = _.find(roles, function(role) {
        return role.value === key;
      });
      return result != null ? result.label : void 0;
    },
    getCurrentProject: function() {
      var deferred;
      deferred = $q.defer();
      if (currentProject != null) {
        deferred.resolve(currentProject);
      }
      ScrumbleUser.getCurrentUser().then(function(user) {
        if (user == null) {
          return deferred.reject('no-user');
        }
        if (user.project == null) {
          return deferred.reject('no-project');
        }
        return Project.find(user.project.objectId).then(function(project) {
          currentProject = project;
          return deferred.resolve(project);
        })["catch"](function(err) {
          if (err.status === 404) {
            return deferred.reject('no-project');
          }
        });
      });
      return deferred.promise;
    },
    setCurrentProject: function(project) {
      return currentProject = project;
    }
  };
});

angular.module('Scrumble.sprint').config(function($stateProvider) {
  return $stateProvider.state('tab.new-sprint', {
    url: '/sprint/edit',
    controller: 'EditSprintCtrl',
    templateUrl: 'sprint/states/edit/view.html',
    resolve: {
      sprint: function(ScrumbleUser, Project, Sprint) {
        return ScrumbleUser.getCurrentUser().then(function(user) {
          return new Sprint({
            project: new Project(user.project),
            info: {
              bdcTitle: 'Burndown Chart'
            },
            number: null,
            goal: null,
            doneColumn: null,
            dates: {
              start: null,
              end: null,
              days: []
            },
            resources: {
              matrix: [],
              speed: null,
              totalPoints: null
            },
            isActive: false
          });
        });
      }
    }
  }).state('tab.edit-sprint', {
    url: '/sprint/:sprintId/edit',
    controller: 'EditSprintCtrl',
    templateUrl: 'sprint/states/edit/view.html',
    resolve: {
      sprint: function(Sprint, $stateParams, $state) {
        return Sprint.find($stateParams.sprintId)["catch"](function(err) {
          return $state.go('tab.new-sprint');
        });
      }
    }
  }).state('tab.sprint-list', {
    url: '/project/:projectId/sprints',
    controller: 'SprintListCtrl',
    templateUrl: 'sprint/states/list/view.html',
    resolve: {
      project: function(Project, $stateParams) {
        return Project.find($stateParams.projectId);
      },
      sprints: function(Sprint, $stateParams) {
        return Sprint.getByProjectId($stateParams.projectId);
      }
    }
  }).state('print-bdc', {
    url: '/project/:projectId/sprint/:sprintId/print',
    controller: 'PrintBDCCtrl',
    templateUrl: 'sprint/states/print-bdc/view.html',
    resolve: {
      project: function(Project, $stateParams) {
        return Project.find($stateParams.projectId);
      },
      sprint: function(Sprint, $stateParams) {
        return Sprint.find($stateParams.sprintId);
      }
    }
  });
});

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

angular.module('Scrumble.storage').factory('Sprint', function(Parse, sprintUtils, $q) {
  var Sprint;
  return Sprint = (function(_super) {
    var find, handleDates;

    __extends(Sprint, _super);

    function Sprint() {
      return Sprint.__super__.constructor.apply(this, arguments);
    }

    Sprint.configure("Sprint", "project", "number", "dates", "resources", "bdcData", "isActive", "doneColumn", "sprintColumn", "bdcBase64", "goal", "indicators");

    find = Sprint.find;

    handleDates = function(sprint) {
      var day, first, last, _i, _len, _ref, _ref1, _ref2, _ref3;
      if ((sprint != null ? sprint.bdcData : void 0) != null) {
        _ref = sprint.bdcData;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          day = _ref[_i];
          day.date = moment(day.date).toDate();
        }
      }
      if (_.isArray(sprint != null ? (_ref1 = sprint.dates) != null ? _ref1.days : void 0 : void 0) && (sprint != null ? (_ref2 = sprint.dates) != null ? _ref2.days.length : void 0 : void 0) > 0) {
        _ref3 = sprint.dates.days, first = _ref3[0], last = _ref3[_ref3.length - 1];
        sprint.dates.start = moment(first.date).toDate();
        sprint.dates.end = moment(last.date).toDate();
      } else {
        if (sprint != null) {
          sprint.dates.start = null;
          sprint.dates.end = null;
        }
      }
      return sprint;
    };

    Sprint.find = function(sprintId) {
      return find.call(this, sprintId).then(function(sprint) {
        return handleDates(sprint);
      });
    };

    Sprint.getActiveSprint = function(project) {
      return this.query({
        where: {
          project: {
            __type: "Pointer",
            className: "Project",
            objectId: project.objectId
          },
          isActive: true
        }
      }).then(function(sprints) {
        var sprint;
        if (sprints.length > 1) {
          console.warn('Several sprints are active for this project');
        }
        sprint = sprints.length > 0 ? sprints[0] : null;
        return handleDates(sprint);
      });
    };

    Sprint.setActiveSprint = function(sprint) {
      sprint.isActive = true;
      return sprint.save();
    };

    Sprint.deactivateSprint = function(sprint) {
      sprint.isActive = false;
      return sprint.save();
    };

    Sprint.getByProjectId = function(projectId) {
      return this.query({
        where: {
          project: {
            __type: "Pointer",
            className: "Project",
            objectId: projectId
          }
        }
      }).then(function(sprints) {
        return _.sortByOrder(sprints, 'number', false);
      }).then(function(sprints) {
        var sprint, _i, _len;
        for (_i = 0, _len = sprints.length; _i < _len; _i++) {
          sprint = sprints[_i];
          handleDates(sprint);
        }
        return sprints;
      });
    };

    Sprint.closeActiveSprint = function(project) {
      return this.getActiveSprint(project).then(function(sprint) {
        sprint.isActive = false;
        return sprint.save();
      });
    };

    Sprint.save = function(sprint) {
      var activeSprint;
      if (sprint.isActive) {
        activeSprint = sprint;
      }
      return sprint.save();
    };

    return Sprint;

  })(Parse.Model);
});

angular.module('Scrumble.sprint').factory('BDCDataProvider', function() {
  var initializeBDC;
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
    initializeBDC: initializeBDC
  };
});

angular.module('Scrumble.sprint').service('bdc', function($q, trelloUtils, Sprint) {
  var getPngBase64;
  getPngBase64 = function(svg) {
    var canvas, ctx, height, img, result, serializer, svgStr, width;
    img = new Image();
    serializer = new XMLSerializer();
    svgStr = serializer.serializeToString(svg);
    img.src = 'data:image/svg+xml;base64,' + window.btoa(svgStr);
    canvas = document.createElement('canvas');
    document.body.appendChild(canvas);
    width = svg.offsetWidth;
    height = svg.offsetHeight;
    canvas.width = svg.offsetWidth;
    canvas.height = svg.offsetHeight;
    ctx = canvas.getContext('2d');
    ctx.fillStyle = 'white';
    ctx.fillRect(0, 0, width, height);
    ctx.drawImage(img, 0, 0, width, height);
    result = canvas.toDataURL('image/png');
    document.body.removeChild(canvas);
    return result;
  };
  return {
    setDonePointsAndSave: function(sprint) {
      var deferred;
      deferred = $q.defer();
      if (sprint.doneColumn != null) {
        trelloUtils.getColumnPoints(sprint.doneColumn).then(function(points) {
          var day, i, _i, _len, _ref;
          _ref = sprint.bdcData;
          for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
            day = _ref[i];
            if (!((day.done != null) || day.done === '')) {
              day.done = points;
              break;
            }
          }
          return Sprint.save(sprint).then(function() {
            return deferred.resolve();
          });
        });
      } else {
        deferred.reject('doneColumn is not set');
      }
      return deferred.promise;
    },
    saveImage: function(sprint, svg) {
      sprint.bdcBase64 = getPngBase64(svg);
      return Sprint.save(sprint);
    }
  };
});

angular.module('Scrumble.sprint').service('sprintUtils', function() {
  var calculateSpeed, calculateTotalPoints, generateDayList, generateResources, getTotalManDays;
  generateDayList = function(start, end) {
    var current, day, days, endM;
    if (!((start != null) && (end != null))) {
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
          date: current.format()
        });
      }
      current.add(1, 'days');
    }
    return days;
  };
  generateResources = function(days, devTeam, previous) {
    var day, index, matrix, member, _i, _len;
    if (previous == null) {
      previous = {
        days: [],
        matrix: []
      };
    }
    if (!((days != null) && (devTeam != null))) {
      return;
    }
    matrix = [];
    for (_i = 0, _len = days.length; _i < _len; _i++) {
      day = days[_i];
      index = _.findIndex(previous.days, day);
      if (index > -1 && devTeam.length === previous.matrix[index].length) {
        matrix.push(previous.matrix[index]);
      } else {
        matrix.push((function() {
          var _j, _len1, _results;
          _results = [];
          for (_j = 0, _len1 = devTeam.length; _j < _len1; _j++) {
            member = devTeam[_j];
            _results.push(1);
          }
          return _results;
        })());
      }
    }
    return matrix;
  };
  getTotalManDays = function(matrix) {
    var cell, line, total, _i, _j, _len, _len1;
    if (matrix == null) {
      matrix = [];
    }
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
  return {
    generateBDC: function(days, resources, previous) {
      var bdc, date, day, fetchDone, i, standard, _i, _len;
      if (previous == null) {
        previous = [];
      }
      standard = 0;
      bdc = [];
      fetchDone = function(date, i) {
        var dayFromPrevious;
        dayFromPrevious = _.find(previous, function(elt) {
          return moment(elt.date).format() === moment(date).format();
        });
        if (dayFromPrevious != null) {
          return dayFromPrevious.done;
        } else if (i === 0) {
          return 0;
        } else {
          return null;
        }
      };
      for (i = _i = 0, _len = days.length; _i < _len; i = ++_i) {
        day = days[i];
        date = moment(day.date).toDate();
        bdc.push({
          date: date,
          standard: standard,
          done: fetchDone(date, i)
        });
        standard += _.sum(resources.matrix[i]) * resources.speed;
      }
      date = moment(day.date).add(1, 'days').toDate();
      bdc.push({
        date: date,
        standard: standard,
        done: fetchDone(date)
      });
      return bdc;
    },
    computeSpeed: function(sprint) {
      var first, last, speed, _ref;
      if (!_.isArray(sprint.bdcData)) {
        return;
      }
      _ref = sprint.bdcData, first = _ref[0], last = _ref[_ref.length - 1];
      if (_.isNumber(last.done)) {
        speed = last.done / sprint.resources.totalManDays;
        return speed.toFixed(1);
      }
    },
    isActivable: function(s) {
      var _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7;
      if ((s.number != null) && (s.doneColumn != null) && (((_ref = s.dates) != null ? _ref.start : void 0) != null) && (((_ref1 = s.dates) != null ? _ref1.end : void 0) != null) && ((_ref2 = s.dates) != null ? (_ref3 = _ref2.days) != null ? _ref3.length : void 0 : void 0) > 0 && ((_ref4 = s.resources) != null ? (_ref5 = _ref4.matrix) != null ? _ref5.length : void 0 : void 0) > 0 && (((_ref6 = s.resources) != null ? _ref6.totalPoints : void 0) != null) && (((_ref7 = s.resources) != null ? _ref7.speed : void 0) != null)) {
        return true;
      } else {
        return false;
      }
    },
    ensureDataConsistency: function(source, sprint, devTeam) {
      var previous;
      if (source === 'number' || source === 'done') {
        return;
      }
      if (source === 'date') {
        previous = {
          days: sprint.dates.days,
          matrix: sprint.resources.matrix
        };
        sprint.dates.days = generateDayList(sprint.dates.start, sprint.dates.end);
        sprint.resources.matrix = generateResources(sprint.dates.days, devTeam, previous);
      }
      if (source === 'team') {
        previous = {
          days: sprint.dates.days,
          matrix: sprint.resources.matrix
        };
        sprint.resources.matrix = generateResources(sprint.dates.days, devTeam, previous);
      }
      if (source === 'date' || source === 'resource' || source === 'speed') {
        sprint.resources.totalManDays = getTotalManDays(sprint.resources.matrix);
        sprint.resources.totalPoints = calculateTotalPoints(sprint.resources.totalManDays, sprint.resources.speed);
      }
      if (source === 'total') {
        return sprint.resources.speed = calculateSpeed(sprint.resources.totalPoints, sprint.resources.totalManDays);
      }
    }
  };
});

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

angular.module('Scrumble.storage').factory('ScrumbleUser', function(Parse, $q, TrelloClient, Project, localStorageService) {
  var NotSoShittyUser;
  return NotSoShittyUser = (function(_super) {
    __extends(NotSoShittyUser, _super);

    function NotSoShittyUser() {
      return NotSoShittyUser.__super__.constructor.apply(this, arguments);
    }

    NotSoShittyUser.configure("NotSoShittyUser", "email", "project");

    NotSoShittyUser.getCurrentUser = function() {
      return this.query({
        where: {
          email: localStorageService.get('trello_email')
        },
        include: 'project'
      }).then(function(user) {
        if (user.length > 0) {
          return user[0];
        } else {
          return null;
        }
      });
    };

    NotSoShittyUser.getBoardId = function() {
      var deferred, token;
      deferred = $q.defer();
      token = localStorageService.get('trello_token');
      if (token == null) {
        deferred.reject('No token');
      }
      TrelloClient.get('/member/me').then(function(response) {
        return response.data;
      }).then(function(userInfo) {
        return UserBoard.query({
          where: {
            email: userInfo.email
          }
        });
      }).then(function(userBoards) {
        if (userBoards.length > 0) {
          return deferred.resolve(userBoards[0].boardId);
        } else {
          return deferred.resolve(null);
        }
      });
      return deferred.promise;
    };

    NotSoShittyUser.setBoardId = function(boardId) {
      var deferred, token;
      deferred = $q.defer();
      token = localStorageService.get('trello_token');
      if (token == null) {
        deferred.reject('No token');
      }
      return TrelloClient.get('/member/me').then(function(response) {
        return response.data;
      }).then(function(userInfo) {
        return this.query({
          where: {
            email: userInfo.email
          }
        }).then(function(user) {
          var project;
          user = user.length > 0 ? user[0] : null;
          if (typeof board !== "undefined" && board !== null) {
            board.boardId = boardId;
            return board.save();
          } else {
            project = new Project();
            project.boardId = boardId;
            this.project = project;
            return this.save();
          }
        });
      });
    };

    return NotSoShittyUser;

  })(Parse.Model);
});

angular.module('Scrumble.storage').service('userService', function(ScrumbleUser) {
  return {
    getOrCreate: function(email) {
      return ScrumbleUser.query({
        where: {
          email: email
        }
      }).then(function(users) {
        var user;
        if (users.length > 0) {
          return users[0];
        } else {
          user = new User();
          user.email = email;
          return user.save().then(function(user) {
            return user;
          });
        }
      });
    }
  };
});

angular.module('Scrumble.sprint').controller('BoardCtrl', function($scope, $timeout, bdc, trelloUtils, sprintUtils) {
  var getCurrentDayIndex, _ref;
  if (!((_ref = $scope.sprint) != null ? _ref.bdcData : void 0)) {
    $scope.sprint.bdcData = sprintUtils.generateBDC($scope.sprint.dates.days, $scope.sprint.resources, $scope.sprint.bdcData);
  }
  $scope.tableData = angular.copy($scope.sprint.bdcData);
  $scope.selectedIndex = 0;
  getCurrentDayIndex = function(data) {
    var day, i, _i, _len;
    if (data == null) {
      return 0;
    }
    for (i = _i = 0, _len = data.length; _i < _len; i = ++_i) {
      day = data[i];
      if (day.done == null) {
        return i;
      }
    }
  };
  $scope.currentDayIndex = getCurrentDayIndex($scope.tableData);
  $scope.fetchTrelloDonePoints = function() {
    if ($scope.sprint.doneColumn != null) {
      return trelloUtils.getColumnPoints($scope.sprint.doneColumn).then(function(points) {
        return $scope.tableData[$scope.currentDayIndex].done = points;
      });
    }
  };
  return $scope.save = function() {
    $scope.sprint.bdcData = $scope.tableData;
    $scope.selectedIndex = 0;
    return $timeout(function() {
      var svg;
      svg = d3.select('#bdcgraph')[0][0].firstChild;
      return bdc.saveImage($scope.sprint, svg);
    });
  };
});

angular.module('Scrumble.common').directive('dynamicFieldsList', function() {
  return {
    restrict: 'E',
    templateUrl: 'common/directives/dynamic-fields/view.html',
    scope: {
      availableFields: '='
    }
  };
});

angular.module('Scrumble.common').directive('nssRound', function() {
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

angular.module('Scrumble.common').factory('Avatar', function(TrelloClient) {
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

angular.module('Scrumble.common').controller('TrelloAvatarCtrl', function(Avatar, $scope) {
  var colors, getColor, _ref;
  if (!$scope.size) {
    $scope.size = '50';
  }
  $scope.$watch('member', function(member) {
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
  $scope.displayTooltip = $scope.tooltip === 'true' ? true : false;
  colors = ['#fbb4ae', '#b3cde3', '#ccebc5', '#decbe4', '#fed9a6', '#ffffcc', '#e5d8bd', '#fddaec', '#f2f2f2'];
  getColor = function(initials) {
    var hash;
    if (initials == null) {
      return colors[0];
    }
    hash = initials.charCodeAt(0);
    return colors[hash % 9];
  };
  return $scope.color = getColor((_ref = $scope.member) != null ? _ref.initials : void 0);
});

angular.module('Scrumble.common').directive('trelloAvatar', function() {
  return {
    restrict: 'E',
    templateUrl: 'common/directives/trello-avatar/view.html',
    scope: {
      size: '@',
      member: '=',
      tooltip: '@'
    },
    controller: 'TrelloAvatarCtrl'
  };
});

angular.module('Scrumble.daily-report').directive('markdownHelper', function() {
  return {
    restrict: 'E',
    templateUrl: 'daily-report/directives/markdown-helper/view.html'
  };
});

var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

angular.module('Scrumble.daily-report').controller('PreviousGoalsCtrl', function($scope, $q, nssModal, TrelloClient, trelloCards) {
  var DialogController;
  trelloCards.getDoneCardIds($scope.sprint.doneColumn).then(function(cardIds) {
    var card, _i, _len, _ref, _ref1, _results;
    _ref = $scope.goals;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      card = _ref[_i];
      card.display = true;
      if (_ref1 = card.id, __indexOf.call(cardIds, _ref1) >= 0) {
        _results.push(card.isDone = true);
      } else {
        _results.push(card.isDone = false);
      }
    }
    return _results;
  });
  DialogController = function($scope, $controller, goal) {
    angular.extend(this, $controller('ModalCtrl', {
      $scope: $scope
    }));
    return $scope.goal = goal;
  };
  return $scope.edit = function(ev, goal) {
    return nssModal.show({
      controller: DialogController,
      templateUrl: 'daily-report/directives/previous-goals/edit-goal.html',
      targetEvent: ev,
      resolve: {
        goal: function() {
          return angular.copy(goal);
        }
      }
    }).then(function(editedGoal) {
      goal.isDone = editedGoal.isDone;
      return goal.name = editedGoal.name;
    });
  };
});

angular.module('Scrumble.daily-report').directive('previousGoals', function() {
  return {
    restrict: 'E',
    templateUrl: 'daily-report/directives/previous-goals/view.html',
    scope: {
      goals: '=',
      sprint: '='
    },
    controller: 'PreviousGoalsCtrl'
  };
});

angular.module('Scrumble.daily-report').controller('SelectGoalsCtrl', function($scope, $q, nssModal, TrelloClient, trelloCards) {
  var DialogController;
  trelloCards.getTodoCards($scope.project, $scope.sprint).then(function(cards) {
    return $scope.trelloCards = cards;
  });
  $scope.updateGoals = function() {
    return $scope.goals = _.filter($scope.trelloCards, 'selected');
  };
  DialogController = function($scope, $controller, goal) {
    angular.extend(this, $controller('ModalCtrl', {
      $scope: $scope
    }));
    return $scope.goal = goal;
  };
  return $scope.edit = function(ev, goal) {
    return nssModal.show({
      controller: DialogController,
      templateUrl: 'daily-report/directives/select-goals/edit-goal.html',
      targetEvent: ev,
      resolve: {
        goal: function() {
          return angular.copy(goal);
        }
      }
    }).then(function(editedGoal) {
      return goal.name = editedGoal;
    });
  };
});

angular.module('Scrumble.daily-report').directive('selectGoals', function() {
  return {
    restrict: 'E',
    templateUrl: 'daily-report/directives/select-goals/view.html',
    scope: {
      goals: '=',
      project: '=',
      sprint: '='
    },
    controller: 'SelectGoalsCtrl'
  };
});

angular.module('Scrumble.daily-report').controller('EditTemplateCtrl', function($scope, $mdToast, mailer, reportBuilder, dailyReport, dynamicFields) {
  var saveFeedback;
  reportBuilder.init();
  saveFeedback = $mdToast.simple().hideDelay(1000).position('top right').content('Saved!');
  $scope.dailyReport = dailyReport;
  $scope.availableFields1 = dynamicFields.getAvailableFields().slice(0, 7);
  $scope.availableFields2 = _.union(dynamicFields.getAvailableFields().slice(7), reportBuilder.getAvailableFields());
  return $scope.save = function() {
    return $scope.dailyReport.save().then(function() {
      return $mdToast.show(saveFeedback);
    });
  };
});

angular.module('Scrumble.daily-report').controller('PreviewCtrl', function($scope, $sce, $mdDialog, $mdToast, googleAuth, mailer, message, rawMessage, reportBuilder, dailyReport, todaysGoals, previousGoals, sections) {
  $scope.message = message;
  $scope.trustAsHtml = function(string) {
    return $sce.trustAsHtml(string);
  };
  $scope.hide = function() {
    return $mdDialog.hide();
  };
  $scope.cancel = function() {
    return $mdDialog.cancel();
  };
  $scope.login = function() {
    return googleAuth.login().then(function() {
      return googleAuth.isAuthenticated().then(function(isAuthenticated) {
        return $scope.isAuthenticated = isAuthenticated;
      });
    });
  };
  googleAuth.isAuthenticated().then(function(isAuthenticated) {
    return $scope.isAuthenticated = isAuthenticated;
  });
  return $scope.send = function() {
    return reportBuilder.render(rawMessage, previousGoals, todaysGoals, sections, true).then(function(message) {
      return mailer.send(message, function(response) {
        var errorFeedback, sentFeedback;
        if ((response.code != null) && response.code > 300) {
          errorFeedback = $mdToast.simple().hideDelay(3000).position('top right').content("Failed to send message: '" + response.message + "'");
          $mdToast.show(errorFeedback);
          return $mdDialog.cancel();
        } else {
          dailyReport.metadata = {
            previousGoals: todaysGoals
          };
          dailyReport.save();
          sentFeedback = $mdToast.simple().content('Email sent');
          $mdToast.show(sentFeedback);
          return $mdDialog.cancel();
        }
      });
    });
  };
});

angular.module('Scrumble.daily-report').controller('DailyReportCtrl', function($scope, $mdToast, $mdDialog, $mdMedia, mailer, reportBuilder, dailyReport, sprint, project, dynamicFields) {
  var saveFeedback, _ref;
  $scope.project = project;
  $scope.sprint = sprint;
  reportBuilder.init();
  saveFeedback = $mdToast.simple().hideDelay(1000).position('top right').content('Saved!');
  $scope.dailyReport = dailyReport;
  $scope.todaysGoals = [];
  $scope.previousGoals = (_ref = dailyReport.metadata) != null ? _ref.previousGoals : void 0;
  $scope.sections = {
    problems: "## Problems\n",
    intro: ""
  };
  $scope.save = function() {
    return $scope.dailyReport.save().then(function() {
      return $mdToast.show(saveFeedback);
    });
  };
  $scope.openMenu = function($mdOpenMenu, ev) {
    var originatorEv;
    originatorEv = ev;
    return $mdOpenMenu(ev);
  };
  $scope.openDynamicFields = function(ev) {
    var useFullScreen;
    useFullScreen = $mdMedia('sm' || $mdMedia('xs'));
    return $mdDialog.show({
      controller: 'DynamicFieldsModalCtrl',
      templateUrl: 'daily-report/states/template/dynamic-fields.html',
      parent: angular.element(document.body),
      targetEvent: ev,
      clickOutsideToClose: true,
      fullscreen: useFullScreen,
      resolve: {
        dailyReport: function() {
          return dailyReport;
        },
        availableFields: function() {
          return _.union(dynamicFields.getAvailableFields(), reportBuilder.getAvailableFields());
        }
      }
    });
  };
  return $scope.preview = function(ev) {
    return $mdDialog.show({
      controller: 'PreviewCtrl',
      templateUrl: 'daily-report/states/preview/view.html',
      parent: angular.element(document.body),
      targetEvent: ev,
      clickOutsideToClose: true,
      fullscreen: $mdMedia('sm'),
      resolve: {
        message: function() {
          return reportBuilder.render($scope.dailyReport.message, _.filter($scope.previousGoals, 'display'), $scope.todaysGoals, $scope.sections, false);
        },
        rawMessage: function() {
          return $scope.dailyReport.message;
        },
        dailyReport: function() {
          return $scope.dailyReport;
        },
        todaysGoals: function() {
          return $scope.todaysGoals;
        },
        previousGoals: function() {
          return _.filter($scope.previousGoals, 'display');
        },
        sections: function() {
          return $scope.sections;
        },
        sprint: function() {
          return sprint;
        }
      }
    });
  };
});

angular.module('Scrumble.indicators').controller('ClientFormCtrl', function($scope, Sprint, loadingToast, defaultSatisfactionForm) {
  var _ref, _ref1, _ref2, _ref3;
  if (((_ref = $scope.sprint) != null ? (_ref1 = _ref.indicators) != null ? _ref1.satisfactionSurvey : void 0 : void 0) != null) {
    $scope.survey = (_ref2 = $scope.sprint) != null ? (_ref3 = _ref2.indicators) != null ? _ref3.satisfactionSurvey : void 0 : void 0;
  } else {
    $scope.survey = angular.copy(defaultSatisfactionForm);
  }
  $scope.save = function() {
    loadingToast.show();
    $scope.saving = true;
    $scope.sprint.indicators = {
      satisfactionSurvey: $scope.survey
    };
    return Sprint.save($scope.sprint).then(function() {
      loadingToast.hide();
      return $scope.saving = false;
    });
  };
  return $scope.print = function() {
    return window.print();
  };
});

angular.module('Scrumble.indicators').service('defaultSatisfactionForm', function() {
  return [
    {
      label: 'What is your appreciation of the speed of the team?',
      type: 'radio',
      items: [
        {
          value: 5,
          label: '5 - Excellent'
        }, {
          value: 4,
          label: '4 - Very good'
        }, {
          value: 3,
          label: '3 - Good'
        }, {
          value: 2,
          label: '2 - Average'
        }, {
          value: 1,
          label: '1 - Insufficient'
        }, {
          value: 0,
          label: '0 - Very insufficient'
        }
      ]
    }, {
      label: 'What is your appreciation of the quality of the coaching?',
      type: 'radio',
      items: [
        {
          value: 5,
          label: '5 - Excellent'
        }, {
          value: 4,
          label: '4 - Very good'
        }, {
          value: 3,
          label: '3 - Good'
        }, {
          value: 2,
          label: '2 - Average'
        }, {
          value: 1,
          label: '1 - Insufficient'
        }, {
          value: 0,
          label: '0 - Very insufficient'
        }
      ]
    }, {
      label: 'What change/improve would make you to improve your appreciation?',
      type: 'textarea'
    }, {
      label: 'If you had a magic wand, what is "the" thing you would change',
      type: 'textarea'
    }, {
      label: 'Would you recommend us?',
      type: 'radio',
      items: [
        {
          value: 'yes-of-course',
          label: 'Yes of course'
        }, {
          value: 'yes',
          label: 'Yes'
        }, {
          value: 'not-really',
          label: 'Not really'
        }, {
          value: 'not-at-all',
          label: 'Not at all'
        }
      ]
    }, {
      label: 'Would you like to have a sales meeting in the coming week?',
      type: 'radio',
      items: [
        {
          value: 'yes',
          label: 'Yes'
        }, {
          value: 'no',
          label: 'No, it is not necessary for now'
        }
      ]
    }
  ];
});

angular.module('Scrumble.indicators').directive('clientForm', function() {
  return {
    restrict: 'E',
    templateUrl: 'indicators/directives/client-form/view.html',
    scope: {
      sprint: '='
    },
    controller: 'ClientFormCtrl'
  };
});

angular.module('Scrumble.indicators').controller('IndicatorsCtrl', function($scope, currentSprint) {
  return $scope.currentSprint = currentSprint;
});

angular.module('Scrumble.login').controller('ProfilInfoCtrl', function($scope, $timeout, $rootScope, trelloAuth, googleAuth) {
  var getTrelloInfo;
  $scope.googleUser = {
    picture: "images/default-profile.jpg"
  };
  $scope.openMenu = function($mdOpenMenu, ev) {
    var originatorEv;
    originatorEv = ev;
    return $mdOpenMenu(ev);
  };
  $scope.logout = trelloAuth.logout;
  getTrelloInfo = function() {
    return trelloAuth.getTrelloInfo().then(function(user) {
      return $scope.userInfo = user;
    });
  };
  getTrelloInfo();
  if (googleAuth.isAuthenticated()) {
    googleAuth.getUserInfo().then(function(user) {
      return $scope.googleUser = user;
    });
  }
  $scope.googleLogin = function() {
    return googleAuth.login().then(function() {
      return googleAuth.getUserInfo().then(function(user) {
        return $scope.googleUser = user;
      });
    });
  };
  return $scope.googleLogout = function() {
    $scope.googleUser = null;
    $scope.googleUser = {
      picture: "images/default-profile.jpg"
    };
    return googleAuth.logout();
  };
});

angular.module('Scrumble.login').directive('profilInfo', function() {
  return {
    restrict: 'E',
    templateUrl: 'login/directives/profil-info/view.html',
    scope: {},
    controller: 'ProfilInfoCtrl'
  };
});

angular.module('Scrumble.login').controller('TrelloLoginCtrl', function($scope, $rootScope, TrelloClient, $state, $auth, ScrumbleUser, localStorageService) {
  $scope.doing = false;
  return $scope.login = function() {
    $scope.doing = true;
    return TrelloClient.authenticate().then(function(response) {
      return TrelloClient.get('/member/me');
    }).then(function(response) {
      return response.data;
    }).then(function(userInfo) {
      return localStorageService.set('trello_email', userInfo.email);
    }).then(function() {
      return ScrumbleUser.getCurrentUser();
    }).then(function(user) {
      if (user == null) {
        user = new ScrumbleUser();
        user.email = localStorageService.get('trello_email');
        return user.save();
      }
    }).then(function() {
      return $state.go('tab.board');
    });
  };
});

angular.module('Scrumble.settings').controller('MemberFormCtrl', function($scope, projectUtils) {
  $scope.daily = projectUtils.getDailyRecipient();
  return $scope.roles = projectUtils.getRoles();
});

angular.module('Scrumble.settings').directive('memberForm', function() {
  return {
    restrict: 'E',
    templateUrl: 'project/directives/member-form/view.html',
    scope: {
      member: '=',
      "delete": '&'
    },
    controller: 'MemberFormCtrl'
  };
});

angular.module('Scrumble.settings').controller('ProjectWidgetCtrl', function($scope, projectUtils) {
  $scope.openMenu = function($mdOpenMenu, ev) {
    var originatorEv;
    originatorEv = ev;
    return $mdOpenMenu(ev);
  };
  return $scope.getRoleLabel = projectUtils.getRoleLabel;
});

angular.module('Scrumble.settings').directive('projectWidget', function() {
  return {
    restrict: 'E',
    templateUrl: 'project/directives/project-widget/view.html',
    scope: {
      project: '='
    },
    controller: 'ProjectWidgetCtrl'
  };
});

angular.module('Scrumble.settings').controller('ResourcesByDayCtrl', function($scope) {
  var changeResource;
  changeResource = function(dayIndex, memberIndex, matrix) {
    matrix[dayIndex][memberIndex] += 0.25;
    if (matrix[dayIndex][memberIndex] > 1) {
      matrix[dayIndex][memberIndex] = 0;
    }
    return matrix;
  };
  $scope.resourceClick = function(i, j) {
    $scope.matrix = angular.copy(changeResource(i, j, $scope.matrix));
    $scope.onUpdate();
  };
  $scope.selected = [];
  return $scope["delete"] = function() {
    var day, index, _i, _len, _ref;
    _ref = $scope.selected;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      day = _ref[_i];
      index = _.findIndex($scope.days, day);
      _.remove($scope.days, day);
      $scope.matrix.splice(index, 1);
    }
    $scope.selected = [];
    return $scope.onUpdate();
  };
});

angular.module('Scrumble.settings').directive('resourcesByDay', function() {
  return {
    restrict: 'E',
    templateUrl: 'project/directives/resources-by-day/view.html',
    scope: {
      members: '=',
      matrix: '=',
      days: '=',
      onUpdate: '&'
    },
    controller: 'ResourcesByDayCtrl'
  };
});

var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

angular.module('Scrumble.settings').controller('SelectPeopleCtrl', function($scope) {
  if ($scope.teamCheck == null) {
    $scope.teamCheck = {};
  }
  $scope.toggle = function(member) {
    var m, _ref;
    if (_ref = member.id, __indexOf.call((function() {
      var _i, _len, _ref1, _results;
      _ref1 = $scope.selectedMembers;
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        m = _ref1[_i];
        _results.push(m.id);
      }
      return _results;
    })(), _ref) >= 0) {
      _.remove($scope.selectedMembers, function(m) {
        return m.id === member.id;
      });
      return $scope.teamCheck[member.id] = false;
    } else {
      $scope.selectedMembers.push(member);
      return $scope.teamCheck[member.id] = true;
    }
  };
  return $scope.$watch('selectedMembers', function(newVal) {
    var member, _i, _len, _results;
    if (!newVal) {
      return;
    }
    $scope.teamCheck = {};
    if (newVal.length > 0) {
      _results = [];
      for (_i = 0, _len = newVal.length; _i < _len; _i++) {
        member = newVal[_i];
        _results.push($scope.teamCheck[member.id] = true);
      }
      return _results;
    }
  }, true);
});

angular.module('Scrumble.settings').directive('selectPeople', function() {
  return {
    restrict: 'E',
    templateUrl: 'project/directives/select-people/view.html',
    scope: {
      members: '=',
      selectedMembers: '='
    },
    controller: 'SelectPeopleCtrl'
  };
});

angular.module('Scrumble.settings').controller('ProjectCtrl', function($location, $mdToast, $scope, $state, $timeout, $q, boards, TrelloClient, localStorageService, Project, Sprint, user, projectUtils) {
  var fetchBoardData, project;
  $scope.boards = boards;
  if (user.project != null) {
    project = user.project;
  } else {
    project = new Project();
  }
  $scope.project = project;
  fetchBoardData = function(boardId) {
    return $q.all([
      TrelloClient.get("/boards/" + boardId + "/lists").then(function(response) {
        return $scope.boardColumns = response.data;
      })["catch"](function(err) {
        $scope.project.boardId = null;
        console.warn("Could not fetch Trello board with id " + boardId);
        return console.log(err);
      }), TrelloClient.get("/boards/" + boardId + "/members?fields=avatarHash,fullName,initials,username").then(function(response) {
        return $scope.boardMembers = response.data;
      })["catch"](function(err) {
        $scope.project.boardId = null;
        console.warn("Could not fetch Trello board members");
        return console.log(err);
      }), Project.get(boardId).then(function(response) {
        if (response != null) {
          return response;
        }
        console.log("No project with boardId " + boardId + " found. Creating a new one");
        project = new Project();
        project.boardId = boardId;
        project.team = [];
        return project.save();
      }).then(function(project) {
        return $scope.project = project;
      })
    ]);
  };
  if ($scope.project.boardId != null) {
    fetchBoardData($scope.project.boardId);
  }
  $scope.$watch('project.boardId', function(next, prev) {
    if (!((next != null) && next !== prev)) {
      return;
    }
    return fetchBoardData(next);
  });
  $scope["delete"] = function(member) {
    return _.remove($scope.project.team, member);
  };
  $scope.saving = false;
  $scope.save = function() {
    $scope.saving = true;
    if ($scope.project.boardId == null) {
      return;
    }
    $scope.project.name = _.find(boards, function(board) {
      return board.id === $scope.project.boardId;
    }).name;
    $scope.project.settings = {
      bdcTitle: 'Sprint #{sprintNumber} - {sprintGoal} - Speed {speed}'
    };
    return $scope.project.save().then(function(savedProject) {
      user.project = savedProject;
      return user.save().then(function() {
        return $scope.$emit('project:update', {
          nextState: 'tab.board'
        });
      })["catch"](function() {
        return $scope.saving = false;
      });
    })["catch"](function() {
      return $scope.saving = false;
    });
  };
});

angular.module('Scrumble.sprint').directive('burndown', function() {
  return {
    restrict: 'AE',
    scope: {
      data: '='
    },
    templateUrl: 'sprint/directives/burndown/view.html',
    link: function(scope, elem, attr) {
      var computeDimensions, config, maxWidth, whRatio;
      maxWidth = 1000;
      whRatio = 0.54;
      computeDimensions = function() {
        var config, height, width;
        if (window.innerWidth > maxWidth) {
          width = 800;
        } else {
          width = window.innerWidth * 0.8;
        }
        height = whRatio * width;
        if (height + 128 > window.innerHeight) {
          height = window.innerHeight * 0.8;
          width = height / whRatio;
        }
        config = {
          containerId: '#bdcgraph',
          width: width,
          height: height,
          margins: {
            top: 30,
            right: 70,
            bottom: 60,
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
          endLabel: 'Ceremony',
          dateFormat: '%A',
          xTitle: '',
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

angular.module('Scrumble.sprint').controller('SprintDetailsCtrl', function($scope, $mdMedia, $mdDialog, Sprint) {
  var BDCDialogController;
  $scope.showBurndown = function(ev, sprint) {
    var useFullScreen;
    useFullScreen = $mdMedia('sm') || $mdMedia('xs');
    return $mdDialog.show({
      controller: BDCDialogController,
      templateUrl: 'sprint/states/list/bdc.dialog.html',
      parent: angular.element(document.body),
      targetEvent: ev,
      clickOutsideToClose: true,
      resolve: {
        sprint: function() {
          return sprint;
        }
      },
      fullscreen: useFullScreen
    });
  };
  $scope.activateSprint = function(sprint) {
    var s, _i, _len, _ref;
    _ref = $scope.sprints;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      s = _ref[_i];
      if (s.isActive && s !== sprint) {
        Sprint.deactivateSprint(s);
      }
    }
    return Sprint.setActiveSprint(sprint).then(function() {
      return $scope.$emit('sprint:update');
    });
  };
  $scope["delete"] = function(event) {
    var confirm;
    confirm = $mdDialog.confirm().title('Delete sprints').textContent('Are you sure you want to do what you\'re trying to do ?').ariaLabel('Delete sprints dialog').targetEvent(event).ok('Delete').cancel('Cancel');
    return $mdDialog.show(confirm).then(function() {
      var sprint, _i, _len, _ref;
      _ref = $scope.selected;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        sprint = _ref[_i];
        sprint.destroy().then(function() {
          return _.remove($scope.sprints, sprint);
        });
      }
      return $scope.selected = [];
    });
  };
  return BDCDialogController = function($scope, $mdDialog, sprint) {
    $scope.sprint = sprint;
    return $scope.cancel = $mdDialog.cancel;
  };
});

angular.module('Scrumble.sprint').directive('sprintDetails', function() {
  return {
    restrict: 'E',
    templateUrl: 'sprint/directives/sprint-details/view.html',
    scope: {
      sprint: '=',
      sprints: '='
    },
    controller: 'SprintDetailsCtrl'
  };
});

angular.module('Scrumble.sprint').controller('SprintWidgetCtrl', function($scope, $timeout, $state, nssModal, sprintUtils, dynamicFields, bdc, Project, Sprint) {
  var DialogController, day, noteInitialized, _i, _len, _ref, _ref1, _ref2;
  dynamicFields.project($scope.project);
  dynamicFields.sprint($scope.sprint);
  if ($scope.sprint.bdcData != null) {
    _ref = $scope.sprint.bdcData;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      day = _ref[_i];
      day.date = moment(day.date).toDate();
    }
  } else {
    noteInitialized = true;
  }
  $scope.sprint.bdcData = sprintUtils.generateBDC($scope.sprint.dates.days, $scope.sprint.resources, $scope.sprint.bdcData);
  if (noteInitialized) {
    $timeout(function() {
      var svg;
      svg = d3.select('#bdcgraph')[0][0].firstChild;
      return bdc.saveImage($scope.sprint, svg);
    });
  }
  dynamicFields.render((_ref1 = $scope.project) != null ? (_ref2 = _ref1.settings) != null ? _ref2.bdcTitle : void 0 : void 0).then(function(title) {
    return $scope.bdcTitle = title;
  });
  $scope.openEditTitle = function(ev) {
    return nssModal.show({
      controller: DialogController,
      templateUrl: 'sprint/directives/sprint-widget/editBDCTitle.html',
      targetEvent: ev,
      resolve: {
        title: function() {
          var _ref3;
          return (_ref3 = $scope.project.settings) != null ? _ref3.bdcTitle : void 0;
        },
        availableFields: function() {
          return dynamicFields.getAvailableFields();
        }
      }
    }).then(function(title) {
      return Project.saveTitle($scope.project, title).then(function(title) {
        return dynamicFields.render(title);
      }).then(function(title) {
        return $scope.bdcTitle = title;
      });
    });
  };
  DialogController = function($scope, $mdDialog, title, availableFields) {
    $scope.title = title;
    $scope.availableFields = availableFields;
    $scope.hide = function() {
      return $mdDialog.hide();
    };
    $scope.cancel = function() {
      return $mdDialog.cancel();
    };
    return $scope.save = function() {
      return $mdDialog.hide($scope.title);
    };
  };
  $scope.updateBDC = function() {
    return bdc.setDonePointsAndSave($scope.sprint).then(function() {
      var svg;
      svg = d3.select('#bdcgraph')[0][0].firstChild;
      return bdc.saveImage($scope.sprint, svg);
    });
  };
  return $scope.printBDC = function() {
    return $state.go('print-bdc', {
      projectId: $scope.project.objectId,
      sprintId: $scope.sprint.objectId
    });
  };
});

angular.module('Scrumble.sprint').directive('sprintWidget', function() {
  return {
    restrict: 'E',
    templateUrl: 'sprint/directives/sprint-widget/view.html',
    scope: {
      project: '=',
      sprint: '=',
      callToActions: '='
    },
    controller: 'SprintWidgetCtrl'
  };
});

angular.module('Scrumble.sprint').controller('EditSprintCtrl', function($scope, $state, TrelloClient, sprintUtils, projectUtils, Project, Sprint, sprint) {
  var save;
  $scope.editedSprint = sprint;
  TrelloClient.get("/boards/" + $scope.project.boardId + "/lists").then(function(response) {
    return $scope.boardLists = response.data;
  });
  $scope.devTeam = projectUtils.getDevTeam($scope.project.team);
  $scope.saveLabel = $state.is('tab.new-sprint') ? 'Start the sprint' : 'Save';
  $scope.title = $state.is('tab.new-sprint') ? 'NEW SPRINT' : 'EDIT SPRINT';
  save = function() {
    if (sprintUtils.isActivable($scope.editedSprint)) {
      return Sprint.closeActiveSprint($scope.project).then(function() {
        return Sprint.save($scope.editedSprint);
      });
    }
  };
  $scope.activable = sprintUtils.isActivable($scope.editedSprint);
  $scope.activate = function() {
    if (sprintUtils.isActivable($scope.editedSprint)) {
      $scope.editedSprint.isActive = true;
      return Sprint.save($scope.editedSprint).then(function(savedSprint) {
        return $scope.$emit('sprint:update', {
          nextState: 'tab.board'
        });
      });
    }
  };
  $scope.checkSprint = function(source) {
    $scope.activable = sprintUtils.isActivable($scope.editedSprint);
    return sprintUtils.ensureDataConsistency(source, $scope.editedSprint, $scope.devTeam);
  };
  return $scope.checkSprint('team');
});

angular.module('Scrumble.sprint').controller('SprintListCtrl', function($scope, sprintUtils, sprints, project) {
  sprints.forEach(function(sprint) {
    sprint.speed = sprintUtils.computeSpeed(sprint);
    sprint.dates.start = moment(sprint.dates.start).format("MMMM Do YYYY");
    return sprint.dates.end = moment(sprint.dates.end).format("MMMM Do YYYY");
  });
  $scope.sprints = sprints;
  return $scope.project = project;
});

angular.module('Scrumble.sprint').controller('PrintBDCCtrl', function($scope, $timeout, sprint, project) {
  $scope.project = project;
  $scope.sprint = sprint;
  return $timeout(function() {
    return window.print();
  }, 500);
});
