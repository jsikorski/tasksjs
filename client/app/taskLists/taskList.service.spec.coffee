'use strict'

describe 'Service: TaskList', ->

  # load the service's module
  beforeEach module 'tasksjsApp'

  # instantiate service
  TaskList = undefined
  beforeEach inject (_TaskList_) ->
    TaskList = _TaskList_

  it 'should do something', ->
    expect(!!TaskList).toBe true