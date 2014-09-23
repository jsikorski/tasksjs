'use strict'

describe 'Directive: focusWhen', ->

  # load the directive's module
  beforeEach module 'tasksjsApp'
  element = undefined
  scope = undefined
  beforeEach inject ($rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<focus-when></focus-when>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the focusWhen directive'
