'use strict'

describe 'Controller: TaskListSharingCtrl', ->

  # load the controller's module
  beforeEach module 'tasksjsApp'
  TaskListSharingCtrl = undefined
  scope = undefined
  taskList = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope, TaskList) ->
    scope = $rootScope.$new()
    taskList = new TaskList()
    TaskListSharingCtrl = $controller 'TaskListSharingCtrl',
      $scope: scope
      taskList: taskList
      socket: { socket: { on: -> } }

  it 'should attach task list to the scope', ->
    expect(scope.taskList).toBeDefined()
    expect(scope.taskList).toEqual(taskList)
