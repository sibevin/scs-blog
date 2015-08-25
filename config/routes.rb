$routes = [
  {
    path: "/index",
    view: "views/pages/homepage",
  },
  {
    path: "/posts",
    view: "views/pages/posts",
    menu: "paper",
  },
  {
    path: "/drafts",
    view: "views/pages/drafts",
    menu: "paper",
  },
  {
    path: "/tags",
    view: "views/pages/tags",
    menu: "tag",
  },
  {
    path: "/categories",
    view: "views/pages/categories",
    menu: "category",
  },
  {
    path: "/works",
    view: "views/pages/works",
    menu: "work",
  },
  {
    path: "/about",
    view: "views/pages/about",
    menu: "wizard",
  },
  {
    path: "/404",
    view: "views/errors/404",
    template: "error",
  },
  {
    path: "/posts/",
    view: /posts\/.+/,
    template: "post",
    menu: "paper",
  },
]
