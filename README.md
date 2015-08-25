# SCS (Slim, Coffeescript and SASS) Blog

## Why?

1. I don't like markdown, it is only a boring plane text and has no table, no block and no css.
2. I want to write some js codes in my post or design a page I want.
3. I need a flexible and elegant way to display tags and categories.
4. I want a smarter search on my blog.
5. It should be a pure static html with js, i.e., no web server is required.

Most of blog frameworks don't meet my requirement, so I build one.

## What?

SCS Blog is a blog framework based on SCS Playground. Write posts with slim, it means you can do anything on your post just like you do on a web page.

## How?

### Install

1. Prepare ruby.
2. Prepare your JavaScript runtime, such as node.js.
3. Run "bundle install".

### Play

1. Run "guard".
2. Run "all" in guard to generate the default files if you want to give it a try.
3. Write your posts in src/slim/posts.
4. Guard would build the html, javascript and css files in build folder automatically.
5. Run "rackup", then you can see a sample blog in localhost:9292.

### Hack

1. Set tags and categories in config/tags.rb and config/categories.rb
2. Set routes in config/routes.rb. If you don't know how to use routes.rb, please trace Guardfile yourself.

## Folders

    ├── build -- where to generate the html files
    │   ├── image -- where to generate the image files
    │   ├── css -- where to generate the css files
    │   │   └── app.css
    │   ├── index.html
    │   └── js -- where to generate the javascript files
    │       └── app.js
    ├── config -- settings for scs-blog
    │   ├── tags.rb
    │   ├── categories.rb
    │   └── compass.rb
    ├── Gemfile
    ├── Gemfile.lock
    ├── Guardfile
    ├── LICENSE
    ├── README.md
    ├── scripts -- utility scripts
    └── src
        ├── coffeescript
        │   └── app
        │       └── js -- where to put the coffeescript files
        │           └── app.js.coffee
        ├── sass -- where to put sass files
        │   └── app.sass
        └── slim -- where to put slim files
            ├── posts -- where to put the post files
            └── index.html.slim

## Meta

You can add metas at the top of your posts, here is an example:

    .meta-data title git tips
    .meta-data description tips for using git
    .meta-data datetime 2014-10-30 15:29:56
    .meta-data tags git,tips
    .meta-data category tools
    .meta-data link git-tips
    .meta-data file 2014-10-30-152956-git-tips
    .meta-data template post
    .meta-data draft
    .meta-data end

## Draft

You can mark your post to be a draft with the draft meta, all drafts are not listed in posts/tags/categories pages and their tags and categories are not included either. You can see all drafts in /drafts.

## Authors

Sibevin Wang

## Copyright

Copyright (c) 2015 Sibevin Wang. Released under the MIT license.
