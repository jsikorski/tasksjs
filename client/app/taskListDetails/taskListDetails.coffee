'use strict'

angular.module 'tasksjsApp'
.config ($stateProvider) ->
	$stateProvider.state 'taskListDetails',
		url: '/taskLists/:taskListId'
		templateUrl: 'app/taskListDetails/taskListDetails.html'
		controller: 'TaskListDetailsCtrl'
		authenticate: true
		resolve:
			taskList: (TaskList, $stateParams) ->
				TaskList.get(id: $stateParams.taskListId).$promise