'use strict'

tasksjsApp = angular.module 'tasksjsApp'

tasksjsApp.controller 'TaskListsCtrl', ($scope, $http, socket, $modal, Auth, User, TaskList, Modal, origin) ->
  $scope.taskLists = []
  $scope.origin = origin

  getUserTaskLists = ->
    $http.get("#{origin}/api/users/#{$scope.currentUser._id}/task-lists").then (response) ->
      _.each response.data, (taskList) -> 
        $scope.taskLists.push(new TaskList(taskList))
      $scope.taskListsLoaded = true

  $scope.currentUser = Auth.getCurrentUser()
  if $scope.currentUser._id? then getUserTaskLists() else $scope.currentUser.$promise.then(getUserTaskLists)

  $scope.addTaskList = ->
    modal = $modal.open
      templateUrl: 'app/taskList/taskListForm.html'
      controller: 'AddTaskListCtrl'

    modal.result.then (taskList) ->
      return if _.find($scope.taskLists, _id: taskList._id)?
      taskList = new TaskList(taskList)
      $scope.taskLists.push(taskList)

  $scope.deleteTaskList = (taskList) ->
    confirm = Modal.confirm.delete -> 
      taskList.$delete().then ->
        index = $scope.taskLists.indexOf(taskList)
        $scope.taskLists.splice(index, 1) unless index is -1
    confirm("listę #{taskList.name}")

  socket.syncUpdates 'task-list', $scope.taskLists, TaskList
  $scope.$on '$destroy', ->
    socket.unsyncUpdates 'task-list'



tasksjsApp.controller 'TaskListCtrl', ($scope, $modal, $state) ->
  $scope.edit = ->
    modal = $modal.open
      templateUrl: 'app/taskList/taskListForm.html'
      controller: 'EditTaskListCtrl'
      resolve: 
        editedTaskList: -> $scope.taskList

    modal.result.then (taskList) ->
      editedTaskList = _.extend($scope.taskList, name: taskList.name)

  $scope.showTaskListDetails = ->
    $state.go('taskListDetails', taskListId: $scope.taskList._id)

  $scope.showTaskListSharing = ->
    $state.go('taskListSharing', taskListId: $scope.taskList._id)



tasksjsApp.controller 'AddTaskListCtrl', ($scope, TaskList) ->
  $scope.title = 'Dodaj listę zadań'
  $scope.taskList = new TaskList()

  $scope.submit = (form) ->
    $scope.submitted = true
    return if form.$invalid
    $scope.taskList.$save()
      .then(-> $scope.$close($scope.taskList))



tasksjsApp.controller 'EditTaskListCtrl', ($scope, editedTaskList, TaskList) ->
  $scope.title = 'Edytuj listę zadań'
  $scope.taskList = new TaskList(_.pick(editedTaskList, '_id', 'name', 'tasks', 'userIds'))

  $scope.submit = (form) ->
    $scope.submitted = true
    return if form.$invalid
    $scope.taskList.$update()
      .then(-> $scope.$close($scope.taskList))