angular.module("scsBlogApp").controller "PostCtrl", [
  '$scope', '$filter', 'APP_POST_DATA', 'CURRENT_FILE'
  ($scope,   $filter,   APP_POST_DATA,   CURRENT_FILE) ->

    initVars = ->
      $scope.current_post = APP_POST_DATA[CURRENT_FILE]

    init = ->
      initVars()

    init()
]