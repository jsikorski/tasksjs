'use strict'

tasksjsApp = angular.module 'tasksjsApp'

tasksjsApp.controller 'TaskListDetailsCtrl', ($scope, $modal, taskList, Modal, socket, taskListErrorResolver, notify) ->
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

	$scope.deleteTask = (task) ->
		confirm = Modal.confirm.delete -> 
			index = $scope.taskList.tasks.indexOf(task)
			return if index is -1
			taskList = angular.copy($scope.taskList)
			taskList.tasks.splice(index, 1)
			taskList.$update()
				.then (taskList) -> _.extend($scope.taskList, taskList)
				.catch (error) -> notify.error(taskListErrorResolver.getErrorMessage(error))

		confirm("zadanie #{task.name}")

	$scope.$watch('taskList.tasks', (-> $scope.taskList.$update()), true)

	socket.socket.on 'task-list:save', (taskList) ->
		_.extend($scope.taskList, taskList) if ($scope.taskList._id is taskList._id)


tasksjsApp.controller 'TaskCtrl', ($scope, $modal) ->
	$scope.edit = ->
		modal = $modal.open
			templateUrl: 'app/task/taskForm.html'
			controller: 'EditTaskCtrl'
			resolve:
				task: -> $scope.task
				taskList: -> $scope.taskList

		modal.result.then (taskList) ->
			_.extend($scope.taskList, taskList)


tasksjsApp.controller 'AddTaskCtrl', ($scope, taskList, taskListErrorResolver) ->
	$scope.title = 'Dodaj zadanie'
	$scope.task = {}
	$scope.taskList = angular.copy(taskList)

	$scope.submit = (form) ->
		$scope.error = undefined
		$scope.submitted = true
		return if form.$invalid
		$scope.taskList.tasks.push($scope.task)
		$scope.taskList.$update()
			.then((taskList) -> $scope.$close(taskList))
			.catch (error) ->
				$scope.error = taskListErrorResolver.getErrorMessage(error)


tasksjsApp.controller 'EditTaskCtrl', ($scope, task, taskList, taskListErrorResolver) ->
	$scope.title = 'Edytuj zadanie'
	$scope.task = angular.copy(task)
	$scope.taskList = angular.copy(taskList)

	$scope.submit = (form) ->
		$scope.error = undefined
		$scope.submitted = true
		return if form.$invalid

		task = _.find($scope.taskList.tasks, _id: task._id)
		index = $scope.taskList.tasks.indexOf(task)
		return if index is -1

		$scope.taskList.tasks[index].name = $scope.task.name
		$scope.taskList.$update()
			.then((taskList) -> $scope.$close(taskList))
			.catch (error) ->
				$scope.error = taskListErrorResolver.getErrorMessage(error)