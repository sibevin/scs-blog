angular.module("scsBlogApp").controller "CategoryListCtrl", [
  '$scope', '$filter', 'APP_CATEGORY_DATA', 'APP_POST_DATA'
  ($scope,   $filter,   APP_CATEGORY_DATA,   APP_POST_DATA) ->

    $scope.getCategories = ->
      categories = $filter("orderBy")(_.values(APP_CATEGORY_DATA), "name")
      categories

    $scope.getCategoryPosts = ->
      filtered_posts = []
      if $scope.current_category != undefined
        posts = _.values(APP_POST_DATA)
        filtered_posts = $filter("filter") posts, (post) ->
          post.draft != true
        filtered_posts = $filter("filter") filtered_posts, (post) ->
          post.category == $scope.current_category.code
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
      if params.c != undefined && APP_CATEGORY_DATA[params.c] != undefined
        $scope.current_category = APP_CATEGORY_DATA[params.c]
        $scope.title = "Category ー " + $scope.current_category.name
        $scope.list_count = 0
      else
        $scope.title = "Categories"
        $scope.list_count = Object.keys(APP_CATEGORY_DATA).length

    init = ->
      initVars()

    init()
]
