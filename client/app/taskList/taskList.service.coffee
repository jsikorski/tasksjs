'use strict'

tasksjsApp = angular.module 'tasksjsApp'

tasksjsApp.factory 'TaskList', ($resource, origin) ->
	TaskList = $resource origin + '/api/task-lists/:id', { id: '@_id' }, {update: method: 'PATCH'}

	TaskList::getNumberOfFinishedTasks = ->
		_.where(@tasks, isFinished: true).length

	TaskList::getNumberOfUnfinishedTasks = ->
		_.where(@tasks, isFinished: false).length

	TaskList