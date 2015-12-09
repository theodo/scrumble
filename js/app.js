'use strict';
var app;

app = angular.module('NotSoShitty', ['ng', 'ngResource', 'ngAnimate', 'ngMaterial', 'md.data.table', 'ui.router', 'app.templates', 'Parse', 'LocalStorageModule', 'satellizer', 'permission', 'trello-api-client', 'NotSoShitty.login', 'NotSoShitty.settings', 'NotSoShitty.storage', 'NotSoShitty.bdc', 'NotSoShitty.common', 'NotSoShitty.daily-report', 'NotSoShitty.feedback']);

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

app.config(function($mdIconProvider) {
  return $mdIconProvider.defaultIconSet('icons/mdi.svg');
});

app.run(function($rootScope, $state) {
  return $rootScope.$state = $state;
});

angular.module('NotSoShitty.common', []);

angular.module('NotSoShitty.daily-report', []);

angular.module('NotSoShitty.feedback', []);

angular.module('NotSoShitty.login', []);

angular.module('NotSoShitty.settings', ['NotSoShitty.common']);

angular.module('NotSoShitty.bdc', []);

angular.module('NotSoShitty.storage', []);

angular.module('NotSoShitty.daily-report').config(function($stateProvider) {
  return $stateProvider.state('daily-report', {
    url: '/daily-report',
    templateUrl: 'daily-report/states/view.html',
    controller: 'DailyReportCtrl',
    resolve: {
      dailyMail: function(NotSoShittyUser) {}
    }
  });
});

angular.module('NotSoShitty.daily-report').controller('DailyReportCtrl', function($scope, dailyMail, DailyMail, $mdToast) {
  $scope.dailyReport = dailyMail;
  $scope.save = function() {
    var saveFeedback;
    saveFeedback = $mdToast.simple().hideDelay(1000).position('top right').content('Saved!');
    return $scope.dailyReport.save().then(function() {
      return $mdToast.show(saveFeedback);
    });
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
    $scope.hide = function() {
      return $mdDialog.hide();
    };
    $scope.cancel = function() {
      return $mdDialog.cancel();
    };
    return $scope.send = function() {
      var feedback;
      console.log('yolo');
      if ($scope.message != null) {
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



angular.module('NotSoShitty.settings').config(function($stateProvider) {
  return $stateProvider.state('project', {
    url: '/project',
    controller: 'SettingsCtrl',
    templateUrl: 'project/states/main/view.html',
    resolve: {
      user: function(NotSoShittyUser) {
        return NotSoShittyUser.getCurrentUser();
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

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

angular.module('NotSoShitty.storage').factory('Project', function(Parse, $q) {
  var Project;
  return Project = (function(_super) {
    __extends(Project, _super);

    function Project() {
      return Project.__super__.constructor.apply(this, arguments);
    }

    Project.configure("Project", "boardId", "name", "columnMapping", "team", "currentSprint");

    Project.get = function(boardId) {
      var deferred;
      deferred = $q.defer();
      if (boardId != null) {
        this.query({
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
    };

    return Project;

  })(Parse.Model);
});

angular.module('NotSoShitty.bdc').config(function($stateProvider) {
  return $stateProvider.state('current-sprint', {
    url: '/sprint/current',
    controller: 'BurnDownChartCtrl',
    templateUrl: 'sprint/states/current-sprint/view.html',
    resolve: {
      sprint: function(NotSoShittyUser, Sprint) {
        return NotSoShittyUser.getCurrentUser().then(function(user) {
          return Sprint.getActiveSprint(user.project);
        })["catch"](function(err) {
          console.log(err);
          return null;
        });
      }
    }
  }).state('new-sprint', {
    url: '/sprint/new',
    controller: 'NewSprintCtrl',
    templateUrl: 'sprint/states/new-sprint/view.html',
    resolve: {
      project: function(NotSoShittyUser, Project) {
        return NotSoShittyUser.getCurrentUser().then(function(user) {
          return new Project(user.project);
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

angular.module('NotSoShitty.storage').factory('Sprint', function(Parse) {
  var Sprint;
  return Sprint = (function(_super) {
    __extends(Sprint, _super);

    function Sprint() {
      return Sprint.__super__.constructor.apply(this, arguments);
    }

    Sprint.configure("Sprint", "project", "number", "dates", "resources", "bdcData", "isActive", "doneColumn");

    Sprint.getActiveSprint = function(project) {
      return this.query({
        where: {
          isActive: true
        }
      }).then(function(sprints) {
        var sprint;
        console.log(sprints);
        sprint = sprints.length > 0 ? sprints[0] : null;
        return sprint;
      })["catch"](function(err) {
        return console.warn(err);
      });
    };

    return Sprint;

  })(Parse.Model);
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

angular.module('NotSoShitty.bdc').service('sprintService', function() {
  return {
    generateDayList: function(start, end) {
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
            date: current.format()
          });
        }
        current.add(1, 'days');
      }
      return days;
    },
    generateResources: function(days, devTeam) {
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
    },
    getTotalManDays: function(matrix) {
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
    },
    calculateTotalPoints: function(totalManDays, speed) {
      return totalManDays * speed;
    },
    calculateSpeed: function(totalPoints, totalManDays) {
      if (!(totalManDays > 0)) {
        return;
      }
      return totalPoints / totalManDays;
    }
  };
});

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

angular.module('NotSoShitty.storage').factory('DailyMail', function(Parse) {
  var DailyMail;
  return DailyMail = (function(_super) {
    __extends(DailyMail, _super);

    function DailyMail() {
      return DailyMail.__super__.constructor.apply(this, arguments);
    }

    DailyMail.configure("DailyMail", "boardId", "to", "cc", "subject", "body");

    return DailyMail;

  })(Parse.Model);
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

angular.module('NotSoShitty.storage').service('DailyMailStorage', function(DailyMail, $q) {
  return {
    get: function(boardId) {
      var deferred;
      deferred = $q.defer();
      if (boardId != null) {
        DailyMail.query({
          where: {
            boardId: boardId
          }
        }).then(function(response) {
          var dailyMail;
          if (response.length > 0) {
            return deferred.resolve(response[0]);
          } else {
            dailyMail = new DailyMail();
            dailyMail.boardId = boardId;
            return dailyMail.save().then(function(object) {
              return deferred.resolve(object);
            });
          }
        })["catch"](deferred.reject);
      } else {
        deferred.reject('No boardId');
      }
      return deferred.promise;
    }
  };
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

angular.module('NotSoShitty.login').controller('LoginCtrl', function($scope, $rootScope, TrelloClient, $state, $auth, NotSoShittyUser, localStorageService) {
  if ($auth.isAuthenticated()) {
    $state.go('project');
  }
  return $scope.login = function() {
    return TrelloClient.authenticate().then(function() {
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
      return $state.go('project');
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
    templateUrl: 'project/directives/resources-by-day/view.html',
    scope: {
      members: '=',
      matrix: '=',
      days: '='
    },
    controller: 'ResourcesByDayCtrl'
  };
});

angular.module('NotSoShitty.settings').controller('SettingsCtrl', function($scope, $timeout, $q, boards, TrelloClient, localStorageService, $mdToast, Project, user) {
  var fetchBoardData, project, promise, saveFeedback;
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
    fetchBoardData(next);
    return $scope.save();
  });
  $scope.$watch('project.team', function(next, prev) {
    if (!((next != null) && !angular.equals(next, prev))) {
      return;
    }
    return $scope.save();
  }, true);
  $scope.clearTeam = function() {
    $scope.project.team.rest = [];
    $scope.project.team.dev = [];
    return $scope.save();
  };
  saveFeedback = $mdToast.simple().hideDelay(1000).position('top right').content('Saved!');
  promise = null;
  $scope.save = function() {
    if ($scope.project.boardId == null) {
      return;
    }
    if (promise != null) {
      $timeout.cancel(promise);
    }
    return promise = $timeout(function() {
      return $scope.project.save().then(function(p) {
        user.project = p;
        return user.save().then(function() {
          return $mdToast.show(saveFeedback);
        });
      });
    }, 2000);
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
    templateUrl: 'project/directives/select-people/view.html',
    scope: {
      members: '=',
      selectedMembers: '='
    },
    controller: 'SelectPeopleCtrl'
  };
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

angular.module('NotSoShitty.bdc').controller('BurnDownChartCtrl', function($scope, $state, BDCDataProvider, TrelloClient, sprint) {
  var day, getCurrentDayIndex, _i, _len, _ref;
  if (sprint == null) {
    $state.go('new-sprint');
  }
  if (sprint.bdcData != null) {
    _ref = sprint.bdcData;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      day = _ref[_i];
      day.date = moment(day.date).toDate();
    }
  } else {
    sprint.bdcData = BDCDataProvider.initializeBDC(sprint.dates.days, sprint.resources);
  }
  $scope.tableData = sprint.bdcData;
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
  $scope.save = function() {
    return sprint.save().then(function() {
      return $scope.currentDayIndex = getCurrentDayIndex($scope.tableData);
    });
  };
  $scope.fetchTrelloDonePoints = function() {
    if (sprint.doneColumn != null) {
      return TrelloClient.get('/lists/' + sprint.doneColumn + '/cards?fields=name').then(function(response) {
        var doneCards;
        doneCards = response.data;
        return $scope.tableData[$scope.currentDayIndex].done = BDCDataProvider.getDonePoints(doneCards);
      })["catch"](function(err) {
        console.log(err);
        return null;
      });
    }
  };
});

angular.module('NotSoShitty.bdc').controller('NewSprintCtrl', function($scope, $timeout, $state, TrelloClient, project, sprintService, Sprint, Project) {
  var isActivable, promise, _base, _ref;
  Project.find("u8o4xBMREA").then(function(o) {
    return console.log(o);
  });
  $scope.project = project;
  console.log(project);
  $scope.sprint = new Sprint({
    project: project,
    number: null,
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
  if ((_base = $scope.sprint).dates == null) {
    _base.dates = {
      start: null,
      end: null,
      days: []
    };
  }
  TrelloClient.get("/boards/" + project.boardId + "/lists").then(function(response) {
    return $scope.boardLists = response.data;
  });
  $scope.devTeam = (_ref = project.team) != null ? _ref.dev : void 0;
  promise = null;
  $scope.save = function() {
    $scope.activable = isActivable();
    if (promise != null) {
      $timeout.cancel(promise);
    }
    return promise = $timeout(function() {
      return $scope.sprint.save();
    }, 1000);
  };
  $scope.activable = false;
  isActivable = function() {
    var s;
    s = $scope.sprint;
    if ((s.number != null) && (s.doneColumn != null) && (s.dates.start != null) && (s.dates.end != null) && s.dates.days.length > 0 && s.resources.matrix.length > 0 && (s.resources.totalPoints != null) && (s.resources.speed != null)) {
      return true;
    } else {
      return false;
    }
  };
  $scope.activate = function() {
    if (isActivable()) {
      $scope.sprint.isActive = true;
      return $scope.sprint.save().then(function() {
        return $state.go('current-sprint');
      });
    }
  };
  $scope.$watch('sprint.dates.end', function(newVal, oldVal) {
    if (newVal === oldVal) {
      return;
    }
    if (newVal == null) {
      return;
    }
    $scope.sprint.dates.days = sprintService.generateDayList($scope.sprint.dates.start, $scope.sprint.dates.end);
    return $scope.save();
  });
  $scope.$watch('sprint.dates.days', function(newVal, oldVal) {
    var _base1, _ref1;
    if (newVal === oldVal) {
      return;
    }
    if ((_base1 = $scope.sprint).resources == null) {
      _base1.resources = {};
    }
    $scope.sprint.resources.matrix = sprintService.generateResources((_ref1 = $scope.sprint.dates) != null ? _ref1.days : void 0, $scope.devTeam);
    return $scope.save();
  });
  $scope.$watch('sprint.resources.matrix', function(newVal, oldVal) {
    if (newVal === oldVal) {
      return;
    }
    if (!newVal) {
      return;
    }
    $scope.sprint.resources.totalManDays = sprintService.getTotalManDays(newVal);
    return $scope.save();
  });
  $scope.$watch('sprint.resources.totalManDays', function(newVal, oldVal) {
    if (newVal === oldVal) {
      return;
    }
    if (!(newVal && newVal > 0)) {
      return;
    }
    $scope.sprint.resources.speed = sprintService.calculateSpeed($scope.sprint.resources.totalPoints, newVal);
    return $scope.save();
  });
  $scope.$watch('sprint.resources.totalPoints', function(newVal, oldVal) {
    if (newVal === oldVal) {
      return;
    }
    if (!((newVal != null) && newVal > 0)) {
      return;
    }
    $scope.sprint.resources.speed = sprintService.calculateSpeed(newVal, $scope.sprint.resources.totalManDays);
    return $scope.save();
  });
  return $scope.$watch('sprint.resources.speed', function(newVal, oldVal) {
    if (newVal === oldVal) {
      return;
    }
    if (!((newVal != null) && newVal > 0)) {
      return;
    }
    $scope.sprint.resources.totalPoints = sprintService.calculateTotalPoints($scope.sprint.resources.totalManDays, newVal);
    return $scope.save();
  });
});
