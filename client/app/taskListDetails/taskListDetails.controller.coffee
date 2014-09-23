'use strict'

tasksjsApp = angular.module 'tasksjsApp'

tasksjsApp.controller 'TaskListDetailsCtrl', ($scope, $modal, taskList) ->
	$scope.taskList = taskList

	$scope.edit = ->
		modal = $modal.open
			templateUrl: 'app/taskList/taskListForm.html'
			controller: 'EditTaskListCtrl'
			resolve: 
				editedTaskList: -> $scope.taskList

		modal.result.then (taskList) ->
			editedTaskList = _.extend($scope.taskList, name: taskList.name)

	$scope.addTask = ->
		modal = $modal.open
			templateUrl: 'app/task/taskForm.html'
			controller: 'AddTaskCtrl'
			resolve:
				taskList: -> $scope.taskList

		modal.result.then (taskList) ->
			_.extend($scope.taskList, taskList)


tasksjsApp.controller 'AddTaskCtrl', ($scope, taskList) ->
	$scope.title = 'Dodaj zadanie'
	$scope.task = {}
	$scope.taskList = angular.copy(taskList)

	$scope.submit = (form) ->
		$scope.submitted = true
		return if form.$invalid
		$scope.taskList.tasks.push($scope.task)
		$scope.taskList.$update()
			.then((taskList) -> $scope.$close(taskList))