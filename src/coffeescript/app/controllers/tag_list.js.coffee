angular.module("scsBlogApp").controller "TagListCtrl", [
  '$scope', '$filter', 'APP_TAG_DATA', 'APP_POST_DATA'
  ($scope,   $filter,   APP_TAG_DATA,   APP_POST_DATA) ->

    $scope.getTags = ->
      tags = _.values(APP_TAG_DATA)
      if $scope.current_tag != undefined
        filtered_tags = $filter("filter") tags, (tag) ->
          cand_tags = $scope.current_tag.code.split("_")
          is_match = false
          for cand_tag in cand_tags
            is_match = true if tag.code.match(cand_tag)
          is_match
        tags = filtered_tags
      tags = $filter("orderBy")(tags, "name")
      tags

    $scope.getTagPosts = ->
      filtered_posts = []
      if $scope.current_tag != undefined
        posts = _.values(APP_POST_DATA)
        filtered_posts = $filter("filter") posts, (post) ->
          post.draft != true
        filtered_posts = $filter("filter") filtered_posts, (post) ->
          _.includes(post.tags, $scope.current_tag.code)
        $scope.list_count = filtered_posts.length
        filtered_posts = $filter("orderBy")(filtered_posts, "datetime", true)
      filtered_posts

    initVars = ->
      params = {}
      if location.search
        parts = location.search.substring(1).split('&')
        ages = for part in parts
          nv = part.split('=')
          if !nv[0]
            continue
          params[nv[0]] = nv[1] or true
      if params.t != undefined && APP_TAG_DATA[params.t] != undefined
        $scope.current_tag = APP_TAG_DATA[params.t]
        $scope.title = "標籤 ー " + $scope.current_tag.name
        $scope.list_count = 0
      else
        $scope.title = "標籤"
        $scope.list_count = Object.keys(APP_TAG_DATA).length

    init = ->
      initVars()

    init()
]