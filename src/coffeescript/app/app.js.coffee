blog_app = angular.module('scsBlogApp', ['tau-utils', 'focus-if'])

blog_app.constant("APP_POST_DATA", POST_DATA)
blog_app.constant("APP_CATEGORY_DATA", CATEGORY_DATA)
blog_app.constant("APP_TAG_DATA", TAG_DATA)

angular.element(document).ready ->
  angular.bootstrap(document, ['scsBlogApp'])