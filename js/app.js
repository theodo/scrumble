'use strict';
var app;

app = angular.module('NotSoShitty', ['ng', 'ngResource', 'ngAnimate', 'ngSanitize', 'ngMaterial', 'md.data.table', 'ui.router', 'app.templates', 'Parse', 'LocalStorageModule', 'satellizer', 'permission', 'trello-api-client', 'NotSoShitty.bdc', 'NotSoShitty.common', 'NotSoShitty.daily-report', 'NotSoShitty.gmail-client', 'NotSoShitty.feedback', 'NotSoShitty.login', 'NotSoShitty.settings', 'NotSoShitty.storage']);

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
    appName: 'Not So Shitty',
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

app.config(function($stateProvider) {
  return $stateProvider.state('tab', {
    abstract: true,
    templateUrl: 'common/states/base.html'
  });
});

angular.module('NotSoShitty.common', ['trello-api-client', 'ngMaterial', 'ui.router']);

angular.module('NotSoShitty.daily-report', []);

angular.module('NotSoShitty.feedback', []);

angular.module('NotSoShitty.gmail-client', []);

angular.module('NotSoShitty.login', ['LocalStorageModule', 'satellizer', 'ui.router', 'permission']);

angular.module('NotSoShitty.settings', ['NotSoShitty.common']);

angular.module('NotSoShitty.bdc', ['ui.router', 'Parse', 'ngMaterial']);

angular.module('NotSoShitty.storage', []);

angular.module('NotSoShitty.common').run(function($rootScope, $state, $window) {
  var finish;
  finish = function() {
    return $window.loading_screen.finish();
  };
  $rootScope.$on('$stateChangeSuccess', finish);
  $rootScope.$on('$stateChangeError', finish);
  return $rootScope.$on('$stateNotFound', finish);
});

angular.module('NotSoShitty.common').config(function($mdThemingProvider) {
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

angular.module('NotSoShitty.common').service('dynamicFields', function($q, trelloUtils) {
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
          return sprint.resources.totalPoints;
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

angular.module('NotSoShitty.common').service('trelloUtils', function(TrelloClient) {
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

angular.module('NotSoShitty.daily-report').config(function($stateProvider) {
  return $stateProvider.state('tab.daily-report', {
    url: '/daily-report',
    templateUrl: 'daily-report/states/template/view.html',
    controller: 'DailyReportCtrl',
    resolve: {
      dailyReport: function(NotSoShittyUser, DailyReport, Project) {
        return NotSoShittyUser.getCurrentUser().then(function(user) {
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
      sprint: function(NotSoShittyUser, Sprint) {
        return NotSoShittyUser.getCurrentUser().then(function(user) {
          return Sprint.getActiveSprint(user.project);
        })["catch"](function(err) {
          console.log(err);
          return null;
        });
      }
    }
  });
});

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

angular.module('NotSoShitty.daily-report').factory('DailyReport', function(Parse) {
  var DailyReport;
  return DailyReport = (function(_super) {
    __extends(DailyReport, _super);

    function DailyReport() {
      return DailyReport.__super__.constructor.apply(this, arguments);
    }

    DailyReport.configure("DailyReport", "project", "message");

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

angular.module('NotSoShitty.daily-report').service('reportBuilder', function($q, NotSoShittyUser, Sprint, Project, trelloUtils, dynamicFields) {
  var converter, isAhead, project, promise, renderBDC, renderBehindAhead, renderCc, renderColor, renderTo, sprint;
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
      var devsEmails, member, memberEmails;
      devsEmails = (function() {
        var _i, _len, _ref, _results;
        _ref = project.team.dev;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          member = _ref[_i];
          if (member.daily === 'to') {
            _results.push(member.email);
          }
        }
        return _results;
      })();
      memberEmails = (function() {
        var _i, _len, _ref, _results;
        _ref = project.team.rest;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          member = _ref[_i];
          if (member.daily === 'to') {
            _results.push(member.email);
          }
        }
        return _results;
      })();
      message.to = _.filter(_.union(devsEmails, memberEmails));
      return message;
    });
  };
  renderCc = function(message) {
    return promise.then(function() {
      var devsEmails, member, memberEmails;
      devsEmails = (function() {
        var _i, _len, _ref, _results;
        _ref = project.team.dev;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          member = _ref[_i];
          if (member.daily === 'cc') {
            _results.push(member.email);
          }
        }
        return _results;
      })();
      memberEmails = (function() {
        var _i, _len, _ref, _results;
        _ref = project.team.rest;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          member = _ref[_i];
          if (member.daily === 'cc') {
            _results.push(member.email);
          }
        }
        return _results;
      })();
      message.cc = _.filter(_.union(devsEmails, memberEmails));
      return message;
    });
  };
  return {
    init: function() {
      return promise = NotSoShittyUser.getCurrentUser().then(function(user) {
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
    render: function(message, useCid) {
      message = angular.copy(message);
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

angular.module('NotSoShitty.feedback').controller('feedbackCallToActionCtrl', function($scope, $mdDialog, $mdMedia) {
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
  return DialogController = function($scope, $mdDialog, Feedback, localStorageService) {
    $scope.message = null;
    $scope.doing = false;
    $scope.hide = function() {
      return $mdDialog.hide();
    };
    $scope.cancel = function() {
      return $mdDialog.cancel();
    };
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

angular.module('NotSoShitty.feedback').directive('feedback', function() {
  return {
    restrict: 'E',
    templateUrl: 'feedback/directives/call-to-action.html',
    scope: {},
    controller: 'feedbackCallToActionCtrl'
  };
});

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

angular.module('NotSoShitty.feedback').factory('Feedback', function(Parse) {
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

angular.module('NotSoShitty.gmail-client').constant('SEND_EMAIL_ENDPOINT', 'https://content.googleapis.com/gmail/v1/users/me/messages/send').service('gmailClient', function($http, googleAuth, SEND_EMAIL_ENDPOINT) {
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

angular.module('NotSoShitty.gmail-client').service('mailer', function($state, $rootScope, gmailClient, googleAuth) {
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

angular.module('NotSoShitty.login').config(function($authProvider) {
  return $authProvider.google({
    clientId: '605908567890-3bg3dmamghq5gd7i9sqsdhvoflef0qku.apps.googleusercontent.com',
    scope: ['https://www.googleapis.com/auth/userinfo.email', 'https://www.googleapis.com/auth/gmail.send'],
    redirectUri: window.location.origin + window.location.pathname,
    responseType: 'token'
  });
});

angular.module('NotSoShitty.login').run(function(Permission, localStorageService) {
  return Permission.defineRole('trello-authenticated', function() {
    return localStorageService.get('trello_token') != null;
  });
});

angular.module('NotSoShitty.login').config(function($stateProvider) {
  return $stateProvider.state('trello-login', {
    url: '/login/trello',
    controller: 'TrelloLoginCtrl',
    templateUrl: 'login/states/trello/view.html'
  });
});

angular.module('NotSoShitty.login').service('googleAuth', function($state, $auth, $http, $q, localStorageService) {
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

angular.module('NotSoShitty.login').service('trelloAuth', function(localStorageService, TrelloClient, $state) {
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
    }
  };
});

angular.module('NotSoShitty.settings').config(function($stateProvider) {
  return $stateProvider.state('tab.project', {
    url: '/project',
    controller: 'ProjectCtrl',
    templateUrl: 'project/states/main/view.html',
    resolve: {
      user: function(NotSoShittyUser, localStorageService, $state) {
        return NotSoShittyUser.getCurrentUser().then(function(user) {
          if (user == null) {
            localStorageService.clearAll();
            $state.go('trello-login');
          }
          return user;
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
        redirectTo: 'trello-login'
      }
    }
  });
});

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

angular.module('NotSoShitty.storage').factory('Project', function(Parse, $q) {
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

    return Project;

  })(Parse.Model);
});

angular.module('NotSoShitty.bdc').config(function($stateProvider) {
  return $stateProvider.state('tab.current-sprint', {
    url: '/',
    controller: 'CurrentSprintCtrl',
    templateUrl: 'sprint/states/current-sprint/view.html',
    resolve: {
      sprint: function(NotSoShittyUser, Sprint, $state) {
        return NotSoShittyUser.getCurrentUser().then(function(user) {
          if (user == null) {
            return $state.go('trello-login');
          }
          if (user.project == null) {
            return $state.go('tab.project');
          }
          return Sprint.getActiveSprint(user.project);
        }).then(function(sprint) {
          if (sprint == null) {
            $state.go('tab.new-sprint');
          }
          return sprint;
        });
      },
      project: function(NotSoShittyUser, Project, $state) {
        return NotSoShittyUser.getCurrentUser().then(function(user) {
          if (user == null) {
            return $state.go('trello-login');
          }
          if (user.project == null) {
            return $state.go('tab.project');
          }
          return Project.find(user.project.objectId);
        })["catch"](function(err) {
          if (err.status === 404) {
            return $state.go('tab.project');
          }
        });
      }
    }
  }).state('tab.new-sprint', {
    url: '/sprint/edit',
    controller: 'EditSprintCtrl',
    templateUrl: 'sprint/states/edit/view.html',
    resolve: {
      project: function(NotSoShittyUser, Project) {
        return NotSoShittyUser.getCurrentUser().then(function(user) {
          return new Project(user.project);
        })["catch"](function(err) {
          console.log(err);
          return null;
        });
      },
      sprint: function(NotSoShittyUser, Project, Sprint) {
        return NotSoShittyUser.getCurrentUser().then(function(user) {
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
      project: function(NotSoShittyUser, Project) {
        return NotSoShittyUser.getCurrentUser().then(function(user) {
          return new Project(user.project);
        })["catch"](function(err) {
          console.log(err);
          return null;
        });
      },
      sprint: function(Sprint, $stateParams, $state) {
        return Sprint.find($stateParams.sprintId).then(function(sprint) {
          var day, _i, _len, _ref, _ref1, _ref2;
          if (sprint.bdcData != null) {
            _ref = sprint.bdcData;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              day = _ref[_i];
              day.date = moment(day.date).toDate();
            }
          }
          if ((sprint != null ? (_ref1 = sprint.dates) != null ? _ref1.start : void 0 : void 0) != null) {
            sprint.dates.start = moment(sprint.dates.start).toDate();
          }
          if ((sprint != null ? (_ref2 = sprint.dates) != null ? _ref2.end : void 0 : void 0) != null) {
            sprint.dates.end = moment(sprint.dates.end).toDate();
          }
          return sprint;
        })["catch"](function(err) {
          console.warn(err);
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
  });
});

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

angular.module('NotSoShitty.storage').factory('Sprint', function(Parse) {
  var Sprint;
  return Sprint = (function(_super) {
    __extends(Sprint, _super);

    function Sprint() {
      return Sprint.__super__.constructor.apply(this, arguments);
    }

    Sprint.configure("Sprint", "project", "number", "dates", "resources", "bdcData", "isActive", "doneColumn", "bdcBase64", "goal");

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
        sprint = sprints.length > 0 ? sprints[0] : null;
        return sprint;
      })["catch"](function(err) {
        return console.warn(err);
      });
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
      });
    };

    Sprint.close = function(sprint) {
      sprint.isActive = false;
      return sprint.save();
    };

    return Sprint;

  })(Parse.Model);
});

angular.module('NotSoShitty.bdc').factory('BDCDataProvider', function() {
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

angular.module('NotSoShitty.bdc').service('bdc', function($q, trelloUtils) {
  return {
    getPngBase64: function(svg) {
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
    },
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
          return sprint.save().then(function() {
            return deferred.resolve();
          });
        });
      } else {
        deferred.reject('doneColumn is not set');
      }
      return deferred.promise;
    }
  };
});

angular.module('NotSoShitty.bdc').service('sprintUtils', function() {
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
      fetchDone = function(date) {
        var dayFromPrevious, done;
        dayFromPrevious = _.find(previous, function(elt) {
          return moment(elt.date).format() === moment(date).format();
        });
        return done = dayFromPrevious != null ? dayFromPrevious.done : null;
      };
      for (i = _i = 0, _len = days.length; _i < _len; i = ++_i) {
        day = days[i];
        date = moment(day.date).toDate();
        bdc.push({
          date: date,
          standard: standard,
          done: fetchDone(date)
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

angular.module('NotSoShitty.storage').factory('NotSoShittyUser', function(Parse, $q, TrelloClient, Project, localStorageService) {
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

angular.module('NotSoShitty.storage').service('userService', function(NotSoShittyUser) {
  return {
    getOrCreate: function(email) {
      return NotSoShittyUser.query({
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

angular.module('NotSoShitty.common').directive('dynamicFieldsList', function() {
  return {
    restrict: 'E',
    templateUrl: 'common/directives/dynamic-fields/view.html',
    scope: {
      availableFields: '='
    }
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

angular.module('NotSoShitty.common').directive('trelloAvatar', function() {
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

angular.module('NotSoShitty.daily-report').controller('PreviewCtrl', function($scope, $sce, $mdDialog, $mdToast, googleAuth, mailer, message, rawMessage, reportBuilder) {
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
    return reportBuilder.render(rawMessage, true).then(function(message) {
      return mailer.send(message, function(response) {
        var errorFeedback, sentFeedback;
        if ((response.code != null) && response.code > 300) {
          errorFeedback = $mdToast.simple().hideDelay(3000).position('top right').content("Failed to send message: '" + response.message + "'");
          $mdToast.show(errorFeedback);
          return $mdDialog.cancel();
        } else {
          sentFeedback = $mdToast.simple().hideDelay(1000).position('top right').content('Email sent');
          $mdToast.show(sentFeedback);
          return $mdDialog.cancel();
        }
      });
    });
  };
});

angular.module('NotSoShitty.daily-report').controller('DailyReportCtrl', function($scope, $mdToast, $mdDialog, $mdMedia, mailer, reportBuilder, dailyReport, sprint, dynamicFields) {
  var saveFeedback;
  reportBuilder.init();
  saveFeedback = $mdToast.simple().hideDelay(1000).position('top right').content('Saved!');
  $scope.dailyReport = dailyReport;
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
          return reportBuilder.render($scope.dailyReport.message, false);
        },
        rawMessage: function() {
          return $scope.dailyReport.message;
        },
        sprint: function() {
          return sprint;
        }
      }
    });
  };
});

angular.module('NotSoShitty.daily-report').controller('DynamicFieldsModalCtrl', function($scope, $mdDialog, availableFields, dailyReport) {
  $scope.availableFields = availableFields;
  $scope.dailyReport = dailyReport;
  $scope.hide = function() {
    return $mdDialog.hide();
  };
  $scope.cancel = function() {
    return $mdDialog.cancel();
  };
  return $scope.save = function() {
    return dailyReport.save().then(function() {
      return $mdDialog.hide();
    });
  };
});

angular.module('NotSoShitty.login').controller('ProfilInfoCtrl', function($scope, $timeout, $rootScope, trelloAuth, googleAuth) {
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

angular.module('NotSoShitty.login').directive('profilInfo', function() {
  return {
    restrict: 'E',
    templateUrl: 'login/directives/profil-info/view.html',
    scope: {},
    controller: 'ProfilInfoCtrl'
  };
});

angular.module('NotSoShitty.login').controller('TrelloLoginCtrl', function($scope, $rootScope, TrelloClient, $state, $auth, NotSoShittyUser, localStorageService) {
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
      return NotSoShittyUser.getCurrentUser();
    }).then(function(user) {
      if (user == null) {
        user = new NotSoShittyUser();
        user.email = localStorageService.get('trello_email');
        return user.save();
      }
    }).then(function() {
      return $state.go('tab.current-sprint');
    });
  };
});

angular.module('NotSoShitty.settings').controller('ProjectWidgetCtrl', function($scope) {
  return $scope.openMenu = function($mdOpenMenu, ev) {
    var originatorEv;
    originatorEv = ev;
    return $mdOpenMenu(ev);
  };
});

angular.module('NotSoShitty.settings').directive('projectWidget', function() {
  return {
    restrict: 'E',
    templateUrl: 'project/directives/project-widget/view.html',
    scope: {
      project: '='
    },
    controller: 'ProjectWidgetCtrl'
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

angular.module('NotSoShitty.settings').directive('resourcesByDay', function() {
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

angular.module('NotSoShitty.settings').controller('SelectPeopleCtrl', function($scope) {
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
    templateUrl: 'project/directives/select-people/view.html',
    scope: {
      members: '=',
      selectedMembers: '='
    },
    controller: 'SelectPeopleCtrl'
  };
});

angular.module('NotSoShitty.settings').controller('ProjectCtrl', function($location, $mdToast, $scope, $state, $timeout, $q, boards, TrelloClient, localStorageService, Project, user) {
  var fetchBoardData, project, saveFeedback;
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
        project.team = {
          rest: [],
          dev: []
        };
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
  $scope.clearTeam = function() {
    $scope.project.team.rest = [];
    $scope.project.team.dev = [];
    return $scope.save();
  };
  saveFeedback = $mdToast.simple().hideDelay(1000).position('top right').content('Saved!');
  $scope.saving = false;
  $scope.save = function() {
    $scope.saving = true;
    if ($scope.project.boardId == null) {
      return;
    }
    $scope.project.name = _.find(boards, function(board) {
      return board.id === $scope.project.boardId;
    }).name;
    return $scope.project.save().then(function(p) {
      user.project = p;
      return user.save().then(function() {
        $mdToast.show(saveFeedback);
        return $state.go('tab.current-sprint');
      })["catch"](function() {
        return $scope.saving = false;
      });
    })["catch"](function() {
      return $scope.saving = false;
    });
  };
  $scope.daily = [
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
  $scope.roles = [
    {
      label: 'Developer',
      value: 'Developer'
    }, {
      label: 'Architect Developer',
      value: 'Architect Developer'
    }, {
      label: 'Product Owner',
      value: 'Product Owner'
    }, {
      label: 'Scrum Master',
      value: 'Scrum Master'
    }, {
      label: 'Stackholder',
      value: 'Stackholder'
    }
  ];
});

angular.module('NotSoShitty.bdc').directive('burndown', function() {
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

angular.module('NotSoShitty.bdc').controller('CurrentSprintCtrl', function($scope, $state, $timeout, $mdDialog, $mdMedia, sprintUtils, TrelloClient, trelloUtils, dynamicFields, bdc, sprint, project, Sprint) {
  var DialogController, day, _i, _len, _ref, _ref1;
  $scope.project = project;
  dynamicFields.project(project);
  dynamicFields.sprint(sprint);
  if (sprint.bdcData != null) {
    _ref = sprint.bdcData;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      day = _ref[_i];
      day.date = moment(day.date).toDate();
    }
  }
  sprint.bdcData = sprintUtils.generateBDC(sprint.dates.days, sprint.resources, sprint.bdcData);
  $scope.sprint = sprint;
  dynamicFields.render((_ref1 = project.settings) != null ? _ref1.bdcTitle : void 0).then(function(title) {
    return $scope.bdcTitle = title;
  });
  $scope.showConfirmNewSprint = function(ev) {
    var confirm;
    confirm = $mdDialog.confirm().title('Start a new sprint').textContent('Starting a new sprint will end this one').targetEvent(ev).ok('OK').cancel('Cancel');
    return $mdDialog.show(confirm).then(function() {
      return Sprint.close($scope.sprint).then(function() {
        return $state.go('tab.new-sprint');
      });
    });
  };
  $scope.openMenu = function($mdOpenMenu, ev) {
    var originatorEv;
    originatorEv = ev;
    return $mdOpenMenu(ev);
  };
  $scope.openEditTitle = function(ev) {
    var useFullScreen;
    useFullScreen = $mdMedia('sm' || $mdMedia('xs'));
    return $mdDialog.show({
      controller: DialogController,
      templateUrl: 'sprint/states/current-sprint/editBDCTitle.html',
      parent: angular.element(document.body),
      targetEvent: ev,
      clickOutsideToClose: true,
      fullscreen: useFullScreen,
      resolve: {
        title: function() {
          var _ref2;
          return (_ref2 = project.settings) != null ? _ref2.bdcTitle : void 0;
        },
        availableFields: function() {
          return dynamicFields.getAvailableFields();
        }
      }
    }).then(function(title) {
      if (project.settings == null) {
        project.settings = {};
      }
      project.settings.bdcTitle = title;
      return project.save().then(function(project) {
        var _ref2;
        return dynamicFields.render((_ref2 = project.settings) != null ? _ref2.bdcTitle : void 0);
      }).then(function(title) {
        return $scope.bdcTitle = title;
      });
    });
  };
  $scope.openEditBDC = function(ev) {
    var useFullScreen;
    useFullScreen = $mdMedia('sm' || $mdMedia('xs'));
    return $mdDialog.show({
      controller: 'EditBDCCtrl',
      templateUrl: 'sprint/states/current-sprint/editBDC.html',
      parent: angular.element(document.body),
      targetEvent: ev,
      clickOutsideToClose: true,
      fullscreen: useFullScreen,
      resolve: {
        data: function() {
          return angular.copy($scope.sprint.bdcData);
        },
        doneColumn: function() {
          return $scope.sprint.doneColumn;
        }
      }
    }).then(function(data) {
      $scope.bdcData = data;
      $scope.sprint.bdcData = data;
      return $timeout(function() {
        var svg;
        svg = d3.select('#bdcgraph')[0][0].firstChild;
        $scope.sprint.bdcBase64 = bdc.getPngBase64(svg);
        return $scope.sprint.save();
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
  $scope.dailyReport = function() {
    return $state.go('tab.daily-report');
  };
  $scope.menuIsOpen = false;
  $scope.tooltipVisible = false;
  $scope.$watch('menuIsOpen', function(isOpen) {
    if (isOpen != null) {
      return $timeout(function() {
        return $scope.tooltipVisible = $scope.menuIsOpen;
      }, 600);
    } else {
      return $scope.tooltipVisible = $scope.menuIsOpen;
    }
  });
  $scope.updateBDC = function() {
    return bdc.setDonePointsAndSave($scope.sprint).then(function() {
      var svg;
      svg = d3.select('#bdcgraph')[0][0].firstChild;
      $scope.sprint.bdcBase64 = bdc.getPngBase64(svg);
      return $scope.sprint.save();
    });
  };
  return $scope.printBDC = function() {
    var popupWin, printContents;
    printContents = document.getElementById('bdcgraph').innerHTML;
    popupWin = window.open('', '_blank');
    popupWin.document.open();
    popupWin.document.write('<html><head><link rel="stylesheet" type="text/css" href="style.css" /></head><body onload="window.print()">' + printContents + '</html>');
    return popupWin.document.close();
  };
});

angular.module('NotSoShitty.bdc').controller('EditBDCCtrl', function($scope, $mdDialog, data, trelloUtils, doneColumn) {
  var getCurrentDayIndex;
  $scope.data = data;
  getCurrentDayIndex = function(data) {
    var day, i, _i, _len;
    for (i = _i = 0, _len = data.length; _i < _len; i = ++_i) {
      day = data[i];
      if (day.done == null) {
        return i;
      }
    }
  };
  $scope.currentDayIndex = getCurrentDayIndex($scope.data);
  $scope.hide = function() {
    return $mdDialog.hide();
  };
  $scope.cancel = function() {
    return $mdDialog.cancel();
  };
  $scope.save = function() {
    return $mdDialog.hide($scope.data);
  };
  return $scope.fetchTrelloDonePoints = function() {
    if (doneColumn != null) {
      return trelloUtils.getColumnPoints(doneColumn).then(function(points) {
        return $scope.data[$scope.currentDayIndex].done = points;
      });
    }
  };
});

angular.module('NotSoShitty.bdc').controller('EditSprintCtrl', function($scope, $timeout, $state, TrelloClient, project, sprintUtils, sprint, Project) {
  var _ref;
  $scope.sprint = sprint;
  TrelloClient.get("/boards/" + project.boardId + "/lists").then(function(response) {
    return $scope.boardLists = response.data;
  });
  $scope.devTeam = (_ref = project.team) != null ? _ref.dev : void 0;
  $scope.saveLabel = $state.is('tab.new-sprint') ? 'Start the sprint' : 'Save';
  $scope.title = $state.is('tab.new-sprint') ? 'NEW SPRINT' : 'EDIT SPRINT';
  $scope.save = function() {
    if (sprintUtils.isActivable($scope.sprint)) {
      return $scope.sprint.save();
    }
  };
  $scope.activable = sprintUtils.isActivable($scope.sprint);
  $scope.activate = function() {
    if (sprintUtils.isActivable($scope.sprint)) {
      $scope.sprint.isActive = true;
      return $scope.sprint.save().then(function() {
        return $state.go('tab.current-sprint');
      });
    }
  };
  $scope.checkSprint = function(source) {
    var _ref1;
    $scope.activable = sprintUtils.isActivable($scope.sprint);
    return sprintUtils.ensureDataConsistency(source, $scope.sprint, project != null ? (_ref1 = project.team) != null ? _ref1.dev : void 0 : void 0);
  };
  return $scope.checkSprint('team');
});

angular.module('NotSoShitty.bdc').controller('SprintListCtrl', function($scope, $mdDialog, $mdMedia, sprintUtils, sprints, project) {
  var BDCDialogController;
  sprints.forEach(function(sprint) {
    sprint.speed = sprintUtils.computeSpeed(sprint);
    sprint.dates.start = moment(sprint.dates.start).format("MMMM Do YYYY");
    return sprint.dates.end = moment(sprint.dates.end).format("MMMM Do YYYY");
  });
  $scope.sprints = sprints;
  $scope.project = project;
  $scope.selected = [];
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
  BDCDialogController = function($scope, $mdDialog, sprint) {
    $scope.sprint = sprint;
    return $scope.cancel = $mdDialog.cancel;
  };
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
  return $scope.activateSprint = function(sprint) {
    var s, _i, _len, _ref;
    _ref = $scope.sprints;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      s = _ref[_i];
      if (s.isActive && s !== sprint) {
        s.isActive = false;
        s.save();
      }
    }
    sprint.isActive = true;
    return sprint.save();
  };
});
