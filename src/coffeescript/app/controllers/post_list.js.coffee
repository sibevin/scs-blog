angular.module("scsBlogApp").controller "PostListCtrl", [
  '$scope', '$filter', 'APP_POST_DATA'
  ($scope,   $filter,   APP_POST_DATA) ->

    $scope.getPosts = ->
      filtered_posts = $filter("orderBy")(_.values(APP_POST_DATA), "datetime", true)
]