'use strict'

angular.module 'tasksjsApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'btford.socket-io',
  'ui.router',
  'ui.bootstrap'
]
.constant('origin', if window.isNodeWebkit or window.isPhoneGap then 'http://jsikorski-tasksjs.herokuapp.com' else '')

.config ($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider) ->
  $urlRouterProvider
  .otherwise '/'

  $stateProvider.state '404',
    url: '/404'
    templateUrl: 'app/errors/404.html'

  $stateProvider.state '500',
    url: '/500'
    templateUrl: 'app/errors/500.html'

  $locationProvider.html5Mode true
  $httpProvider.interceptors.push 'authInterceptor'

.factory 'authInterceptor', ($rootScope, $q, $cookieStore, $location) ->
  # Add authorization token to headers
  request: (config) ->
    config.headers = config.headers or {}

    if $cookieStore.get 'token'
      token = $cookieStore.get('token')
    else
      token = window.localStorage.getItem('token')

    config.headers.Authorization = 'Bearer ' + token if token
    config

  # Intercept 401s and redirect you to login
  responseError: (response) ->
    if response.status is 401
      $location.path '/login'
      # remove any stale tokens
      $cookieStore.remove 'token'

    $q.reject response

.run ($rootScope, $location, Auth, $http, origin, $state) ->
  # Redirect to login if route requires auth and you're not logged in
  $http.get(origin + '/version').then (response) ->
    $rootScope.version = response.data

  $rootScope.$on '$stateChangeStart', (event, next) ->
    Auth.isLoggedInAsync (loggedIn) ->
      $location.path "/login" if next.authenticate and not loggedIn

  $rootScope.$on '$stateChangeError', ->
    response = arguments[5]
    if response.status and response.status is 404
      state = '404'
    else
      state = '500'

    $state.go(state, {}, location: 'replace')