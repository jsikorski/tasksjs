'use strict'

angular.module 'tasksjsApp'
.controller 'SettingsCtrl', ($scope, User, Auth) ->
  $scope.errors = {}
  $scope.changePassword = (form) ->
    $scope.submitted = true

    if form.$valid
      Auth.changePassword $scope.user.oldPassword, $scope.user.newPassword
      .then ->
        $scope.message = 'Hasło zostało zmienione.'

      .catch ->
        form.password.$setValidity 'mongoose', false
        $scope.errors.other = 'Podane hasło nie jest prawidłowe.'
        $scope.message = ''
