'use strict'

angular.module 'tasksjsApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'taskLists',
    url: '/'
    templateUrl: 'app/taskLists/taskLists.html'
    controller: 'TaskListsCtrl'
    authenticate: true
