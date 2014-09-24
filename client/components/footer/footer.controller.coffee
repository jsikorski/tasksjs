'use strict'

angular.module 'tasksjsApp'
.controller 'FooterCtrl', ($scope, $rootScope) ->
	$scope.version = $rootScope.version
  