'use strict'

angular.module 'tasksjsApp'
.controller 'FooterCtrl', ($scope, $rootScope, $http) ->
	$scope.version = $rootScope.version
	unless $scope.version?
		$http.get('/version').then (response) ->
  			$scope.version = response.data