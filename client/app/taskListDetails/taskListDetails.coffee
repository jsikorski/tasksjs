'use strict'

angular.module 'tasksjsApp'
.config ($stateProvider) ->
	$stateProvider
		.state 'taskListDetails',
			url: '/taskLists/:taskListId'
			templateUrl: 'app/taskListDetails/taskListDetails.html'
			controller: 'TaskListDetailsCtrl'
			authenticate: true
			resolve:
				taskList: (TaskList, $stateParams, $state) ->
					taskListId = $stateParams.taskListId
					getTaskList = TaskList.get(id: taskListId).$promise
					getTaskList.catch (response) -> 
						$state.go('taskListUnauthorized', $stateParams, location: 'replace') if response.status is 403
					getTaskList
		
		.state 'taskListUnauthorized',
			url: '/taskLists/:taskListId/unauthorized'
			templateUrl: 'app/taskListDetails/taskListUnauthorized.html'
			authenticate: true