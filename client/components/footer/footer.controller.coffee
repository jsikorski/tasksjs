'use strict'

angular.module 'tasksjsApp'
.controller 'FooterCtrl', ($scope, $rootScope, $http, origin) ->
	$scope.isNodeWebkitApp = require?
	$scope.version = $rootScope.version
	unless $scope.version?
		$http.get(origin + '/version').then (response) ->
  			$scope.version = response.data