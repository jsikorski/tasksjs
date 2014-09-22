'use strict'

tasksjsApp = angular.module 'tasksjsApp'

tasksjsApp.controller 'TaskListsCtrl', ($scope, $http, socket, $modal, Auth, User, TaskList, Modal) ->
  $scope.taskLists = []

  getUserTaskLists = ->
    $http.get("/api/users/#{$scope.currentUser._id}/task-lists").then (response) ->
        $scope.taskLists = _.map(response.data, (taskList) -> new TaskList(taskList))
        socket.syncUpdates 'task-list', $scope.taskLists, TaskList

  $scope.currentUser = Auth.getCurrentUser()
  if $scope.currentUser._id? then getUserTaskLists() else $scope.currentUser.$promise.then(getUserTaskLists)

  $scope.addTaskList = ->
    modal = $modal.open
      templateUrl: 'app/taskLists/taskListForm.html'
      controller: 'AddTaskListCtrl'

    modal.result.then (taskList) ->
      $scope.taskLists.push(taskList)

  $scope.deleteTaskList = (taskList) ->
    confirm = Modal.confirm.delete -> 
      taskList.$delete().then ->
        index = $scope.taskLists.indexOf(taskList)
        $scope.taskLists.splice(index, 1) unless index is -1
    confirm("listę #{taskList.name}")

  $scope.$on '$destroy', ->
    socket.unsyncUpdates 'task-list'



tasksjsApp.controller 'TaskListCtrl', ($scope, Modal) ->
  

tasksjsApp.controller 'AddTaskListCtrl', ($scope, TaskList) ->
  $scope.taskList = new TaskList()

  $scope.submit = (form) ->
    $scope.submitted = true
    return if form.$invalid
    $scope.taskList.$save()
      .then(-> $scope.$close($scope.taskList))