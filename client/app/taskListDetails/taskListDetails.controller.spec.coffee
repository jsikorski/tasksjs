'use strict'

describe 'Controller: TaskListDetailsCtrl', ->

  # load the controller's module
  beforeEach module 'tasksjsApp'
  TaskListDetailsCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    TaskListDetailsCtrl = $controller 'TaskListDetailsCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
