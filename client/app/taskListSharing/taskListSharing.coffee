'use strict'

angular.module 'tasksjsApp'
.config ($stateProvider) ->
	$stateProvider.state 'taskListSharing',
		url: '/taskLists/:taskListId/sharing'
		templateUrl: 'app/taskListSharing/taskListSharing.html'
		controller: 'TaskListSharingCtrl'
		authenticate: true
		resolve:
			taskList: (TaskList, $stateParams, $state) ->
				taskListId = $stateParams.taskListId
				getTaskList = TaskList.get(id: taskListId).$promise
				getTaskList.catch (response) -> 
					$state.go('taskListUnauthorized', $stateParams, location: 'replace') if response.status is 403
				getTaskList