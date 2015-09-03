angular.module("scsBlogApp").controller "LayoutCtrl", [
  '$scope', '$filter', '$window', 'TabSwitcher', 'APP_TAG_DATA', 'APP_CATEGORY_DATA', 'APP_POST_DATA'
  ($scope,   $filter,   $window,   TabSwitcher,   APP_TAG_DATA,   APP_CATEGORY_DATA,   APP_POST_DATA) ->

    $scope.switchFooter = (tab, is_switch = true) ->
      if is_switch
        $scope.footer_ts.switch(tab)
      else
        $scope.footer_ts.setTab(tab)
      $scope.query_keyword = ""

    $scope.getPostTags = (post) ->
      tags = []
      for tag in post.tags
        if APP_TAG_DATA[tag] != undefined
          tags.push(APP_TAG_DATA[tag])
      tags

    $scope.getPostCategory = (post) ->
      category = APP_CATEGORY_DATA[post.category]
      category = { name: "", code: "NONE", count: 0 } if category == undefined
      category

    storePostTagCategoryStr = (post) ->
      post.tag_str = _.pluck($scope.getPostTags(post), "name").join()
      post.category_str = $scope.getPostCategory(post).name
      post

    $scope.getSearchPosts = ->
      filtered_posts = []
      if $scope.query_keyword != undefined && $scope.query_keyword != ""
        posts = _.map(_.values(APP_POST_DATA), storePostTagCategoryStr)
        filtered_posts = $filter("filter") posts, (post) ->
          post.draft != true
        filtered_posts = $filter("filter")(filtered_posts, $scope.query_keyword)
        $scope.search_count = filtered_posts.length
        filtered_posts = $filter("orderBy")(filtered_posts, "datetime", true)
      filtered_posts

    $scope.layoutKeyDown= (event) ->
      if event.keyCode == 27 # esc
        $scope.footer_ts.switch("close")
      unless $scope.footer_ts.isTab("search")
        switch event.keyCode
          when 191 # /
            $scope.footer_ts.switch("search")
          when 77 # m
            $scope.footer_ts.switch("menu")
          when 80 # p
            $window.location.href = "/posts"
          when 84 # t
            $window.location.href = "/tags"
          when 67 # c
            $window.location.href = "/categories"
          when 87 # w
            $window.location.href = "/works"
          when 65 # a
            $window.location.href = "/about"
          when 72 # h
            $window.location.href = "/"

    initVars = ->
      $scope.footer_ts = new TabSwitcher("close")
      $scope.display_mode_ts = new TabSwitcher("web")

    init = ->
      initVars()

    init()
]
