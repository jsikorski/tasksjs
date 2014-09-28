'use strict'

tasksjsApp = angular.module 'tasksjsApp'

tasksjsApp.controller 'TaskListSharingCtrl', ($scope, taskList, $modal, Modal, socket) ->
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
			taskList.$update().then (taskList) ->
				_.extend($scope.taskList, taskList)
		confirm('Potwierdź zatrzymanie udostępniania', 
			'<p>Czy na pewno chcesz przestać udostępniać listę użytkownikowi <strong>' + user.name + '</strong> ?</p>')

	socket.socket.on 'task-list:save', (taskList) ->
		_.extend($scope.taskList, taskList) if ($scope.taskList._id is taskList._id)


tasksjsApp.controller 'ShareCtrl', ($scope, taskList) ->
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
				if error.status is 403
					$scope.error = 'Nie masz uprawnień do tej listy zadań.'
				else if error.status is 404
					$scope.error = 'Lista zadań nie została znaleziona.'
				else
					$scope.error = error.data.message ? 'Wystąpił nieznany błąd.'
