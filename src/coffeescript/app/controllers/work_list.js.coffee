angular.module("scsBlogApp").controller "WorkListCtrl", [
  '$scope', '$filter', 'APP_POST_DATA'
  ($scope,   $filter,   APP_POST_DATA) ->

    $scope.getPosts = ->
      filtered_posts = $filter("filter") _.values(APP_POST_DATA), (post) ->
        _.includes(post.tags, "work")
      $scope.list_count = filtered_posts.length
      filtered_posts = $filter("orderBy")(filtered_posts, "datetime", true)
      filtered_posts
]