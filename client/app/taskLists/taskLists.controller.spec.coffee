'use strict'

describe 'Controller: TaskListsCtrl', ->

  # load the controller's module
  beforeEach module 'tasksjsApp' 
  beforeEach module 'socketMock' 

  TaskListsCtrl = undefined
  scope = undefined
  currentUser = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope, Auth, User) ->
    scope = $rootScope.$new()
    currentUser = new User(_id: 1)
    TaskListsCtrl = $controller 'TaskListsCtrl',
      $scope: scope
      Auth: { getCurrentUser: -> currentUser }


  it 'should attach current user to the scope', ->
    expect(scope.currentUser).toBeDefined()
    expect(scope.currentUser).toEqual(currentUser)