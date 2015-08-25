angular.module("scsBlogApp").controller "DraftListCtrl", [
  '$scope', '$filter', 'APP_POST_DATA'
  ($scope,   $filter,   APP_POST_DATA) ->

    $scope.getPosts = ->
      posts = _.values(APP_POST_DATA)
      filtered_posts = $filter("filter") posts, (post) ->
        post.draft == true
      filtered_posts = $filter("orderBy")(filtered_posts, "datetime", true)
]
