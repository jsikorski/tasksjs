'use strict'

tasksjsApp = angular.module 'tasksjsApp'

tasksjsApp.controller 'TaskListSharingCtrl', ($scope, taskList, $modal, Modal, socket, taskListErrorResolver, notify) ->
	$scope.taskList = taskList

	$scope.share = ->
		modal = $modal.open
			templateUrl: 'app/taskListSharing/share.html'
			controller: 'ShareCtrl'
			resolve:
				taskList: -> $scope.taskList

		modal.result.then (taskList) ->
			_.extend($scope.taskList, taskList)

	$scope.stopSharing = (user) ->
		confirm = Modal.confirm.warning -> 
			index = $scope.taskList.permittedUsers.indexOf(user)
			return if index is -1
			taskList = angular.copy($scope.taskList)
			taskList.permittedUsers.splice(index, 1)
			taskList.$update()
				.then (taskList) -> _.extend($scope.taskList, taskList)
				.catch (error) -> notify.error(taskListErrorResolver.getErrorMessage(error))
				
		confirm('Potwierdź zatrzymanie udostępniania', 
			'<p>Czy na pewno chcesz przestać udostępniać listę użytkownikowi <strong>' + user.name + '</strong> ?</p>')

	socket.socket.on 'task-list:save', (taskList) ->
		_.extend($scope.taskList, taskList) if ($scope.taskList._id is taskList._id)


tasksjsApp.controller 'ShareCtrl', ($scope, taskList, taskListErrorResolver) ->
	$scope.user = {}
	$scope.taskList = angular.copy(taskList)

	$scope.submit = (form) ->
		$scope.error = undefined
		$scope.submitted = true
		return if form.$invalid
		$scope.taskList.permittedUsers.push($scope.user)
		$scope.taskList.$update()
			.then((taskList) -> $scope.$close(taskList))
			.catch (error) -> 
				$scope.taskList = angular.copy(taskList)
				$scope.error = taskListErrorResolver.getErrorMessage(error)