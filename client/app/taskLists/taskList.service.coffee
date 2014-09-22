'use strict'

angular.module 'tasksjsApp'
.factory 'TaskList', ($resource) ->
  TaskList = $resource '/api/task-lists/:id', { id: '@_id' }, {update: method: 'PATCH'}

  TaskList::getNumberOfFinishedTasks = ->
  	_.where(@tasks, isFinished: true).length

  TaskList::getNumberOfUnfinishedTasks = ->
  	_.where(@tasks, isFinished: true).length

  TaskList