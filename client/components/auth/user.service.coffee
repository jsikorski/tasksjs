'use strict'

angular.module 'tasksjsApp'
.factory 'User', ($resource, origin) ->
  $resource origin + '/api/users/:id/:controller',
    id: '@_id'
  ,
    changePassword:
      method: 'PUT'
      params:
        controller: 'password'

    get:
      method: 'GET'
      params:
        id: 'me'

    getTaskLists:
      method: 'GET'
      isArray: true
      params:
        controller: 'task-lists'