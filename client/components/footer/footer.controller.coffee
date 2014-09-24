'use strict'

angular.module 'tasksjsApp'
.controller 'FooterCtrl', ($scope, $rootScope, $http) ->
	$scope.version = $rootScope.version
	unless $scope.version?
		$http.get('/version').then (response) ->
  			$sope.version = response.data