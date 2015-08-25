=begin
guard 'slim', slim: { :pretty => true },
              input_root: 'src/slim',
              output_root: 'app/' do
  watch(%r'^.+\.slim$')
end
=end

require 'slim'
require 'slim/include'
require 'fileutils'
require 'uglifier'
require 'logger'
require 'colorize'

require './config/routes.rb'
require './config/meta_defaults.rb'
require './config/tags.rb'
require './config/categories.rb'

$logger = Logger.new(STDOUT)
#$logger.level = Logger::DEBUG
$logger.level = Logger::INFO
$logger.formatter = proc do |severity, datetime, progname, msg|
  "#{datetime.strftime("%T")}: [#{severity[0].upcase * 2}] #{msg}\n"
end

guard :compass, configuration_file: 'config/compass.rb'

coffeescript_options = {
  input: 'src/coffeescript',
  output: 'temp/js',
  patterns: [%r{^src/coffeescript/(.+\.(?:coffee|coffee\.md|litcoffee))$}]
}

guard 'coffeescript', coffeescript_options do
  coffeescript_options[:patterns].each { |pattern| watch(pattern) }
end

module ::Guard
  class PageData
    attr_accessor :meta
    attr_writer :menu
    def menu
      @menu || "none"
    end
  end

  class MetaService
    def self.parse_meta(post_path)
      $logger.debug("#{name}/#{__method__}: post_path =\n  #{post_path}")
      meta_arr = []
      File.open(post_path).each do |line|
        break if line.match(/^\.meta-data\ end/)
        if line.match(/^\.meta-data/)
          meta_arr << line.gsub(/\.meta-data\ /,'').strip.split(" ", 2)
        end
      end
      meta = Hash[meta_arr]
      # NOTE: { "draft" => nil } => { "draft" => true }
      meta.keys.each do |k|
        meta[k] = true if meta[k] == nil
      end
      if meta["tags"] != nil
        meta["tags"] = meta["tags"].split(",")
      else
        meta["tags"] = []
      end
      $logger.debug("#{name}/#{__method__}: meta =\n  #{meta}")
      return meta
    end
  end

  class TagService
    attr_reader :tags

    def initialize(default_tags = {})
      @default_tags = default_tags
      init_tags
    end

    def init_tags
      @tags = {}
      @default_tags.keys.each do |tag|
        self.add(tag, true)
      end
    end

    def add(tag, init = false)
      tag_parts = tag.split("_")
      if tag_parts.count > 1
        handle_sub_tags(tag, tag_parts, init)
      else
        handle_single_tag(tag, init)
      end
    end

    private

    def handle_single_tag(tag, init)
      if @tags[tag]
        @tags[tag][:count] += (init ? 0 : 1)
      else
        tag_name = get_default_value(tag, :name) || tag.capitalize
        tag_color = get_default_value(tag, :color)
        tag_desc = get_default_value(tag, :desc)
        create_tag(tag, (init ? 0 : 1), tag_name, tag_color, tag_desc)
      end
    end

    def handle_sub_tags(tag, tag_parts, init)
      parent_tags = get_parent_tags(tag_parts)
      previous_tag = nil
      parent_tags.each do |pt|
        if @tags[pt]
          @tags[pt][:count] += (init ? 0 : 1) if pt == tag
        else
          if pt == tag
            create_sub_tag(pt, previous_tag, (init ? 0 : 1))
          else
            create_sub_tag(pt, previous_tag, 0)
          end
        end
        previous_tag = @tags[pt]
      end
    end

    # tag_parts = ["a", "b", "c"] => parent_tags = ["a", "a_b", "a_b_c"]
    def get_parent_tags(tag_parts)
      parent_tags = []
      previous_tag = nil
      tag_parts.each do |tp|
        if previous_tag
          parent_tag = "#{previous_tag}_#{tp}"
        else
          parent_tag = tp
        end
        parent_tags << parent_tag
        previous_tag = parent_tag
      end
      return parent_tags
    end

    def create_sub_tag(tag, previous_tag = nil, count = 0)
      previous_name = previous_tag ? "#{previous_tag[:name]} > " : nil
      tag_name = get_default_value(tag, :name)
      tag_name = tag_name || tag.split("_").last.capitalize
      tag_name = "#{previous_name}#{tag_name}"
      tag_color = get_default_value(tag, :color)
      tag_color = tag_color || (previous_tag ? previous_tag[:color] : nil)
      tag_desc = get_default_value(tag, :desc)
      create_tag(tag, count, tag_name, tag_color, tag_desc)
    end

    def create_tag(tag, count, tag_name, tag_color = nil, tag_desc = nil)
      tag_name = replace_dash_to_space(tag_name)
      @tags[tag] = {
        count: count,
        name: tag_name,
        code: tag
      }
      @tags[tag][:color] = tag_color if tag_color
      @tags[tag][:desc] = tag_desc if tag_desc
    end

    def get_default_value(tag, key)
      value = @tags[tag] ? @tags[tag][key] : nil
      value = value || (@default_tags[tag] ? @default_tags[tag][key] : nil)
    end

    # A > b-c > D => A > B C > D
    def replace_dash_to_space(tag_name)
      new_tags = []
      single_tags = tag_name.split(" > ")
      single_tags.map do |st|
        if st.split("-").count > 1
          new_tags << st.split("-").map{ |np| np.capitalize }.join(" ")
        else
          new_tags << st
        end
      end
      return new_tags.join(" > ")
    end
  end

  class RenderSlimGuard < ::Guard::Plugin
    def initialize(options = {})
      @root_path = Pathname.new(File.dirname(__FILE__))
      super
    end

    def run_all
      $logger.debug("#{name}/#{__method__}: triggered.")
      render_multiple_file
    end

    def run_on_changes(paths)
      $logger.debug("#{name}/#{__method__}: triggered.")
      render_slim_file(paths)
    end

    def run_on_modifications(paths)
      $logger.debug("#{name}/#{__method__}: triggered.")
      render_slim_file(paths)
    end

    def run_on_addititions(paths)
      $logger.debug("#{name}/#{__method__}: triggered.")
      render_slim_file(paths)
    end

    private

    def render(route_data, view_path)
      $logger.debug("#{name}/#{__method__}: view_path = \n#{view_path}")
      $logger.debug("#{name}/#{__method__}: route_data = \n#{route_data}")
      if route_data[:layout] == nil
        layout = "src/slim/layout/application.slim"
      else
        layout = "src/slim/layout/#{route_data[:layout]}.slim"
      end
      $logger.debug("#{name}/#{__method__}: layout = #{layout}")

      page_data = PageData.new

      return unless File.file?(view_path)
      main_slim = File.read(view_path)
      meta = MetaService.parse_meta(view_path)
      page_data.meta = $meta_defaults.merge(meta)
      layout_slim = File.read(layout)

      layout_html = Slim::Template.new{ layout_slim }
      main_html = Slim::Template.new{ main_slim }.render(page_data)
      if route_data[:template]
        template_path = "src/slim/template/#{route_data[:template]}.slim"
        $logger.debug("#{name}/#{__method__}: template_path =\n  #{template_path}")
        template_slim = File.read(template_path)
        template_html = Slim::Template.new{ template_slim }
        main_html = template_html.render(page_data) { main_html }
      end
      page_data.menu = route_data[:menu]
      page_html = layout_html.render(page_data) { main_html }

      if route_data[:view].is_a?(Regexp)
        output_path = "build#{route_data[:path]}#{meta["file"]}.html"
      else
        output_path = "build#{route_data[:path]}.html"
      end
      output_dir = File.dirname(output_path)
      unless File.directory?(output_dir)
        FileUtils.mkdir_p(output_dir)
      end

      File.open(output_path, 'w') do |f|
        f.puts page_html
      end
      $logger.info("#{name}/#{__method__}: output_path =\n  #{output_path}".light_cyan)
    end

    def render_slim_file(paths = [])
      paths.each do |path|
        slim_path = path.gsub(/src\/slim\//, '')
        if slim_path =~ /layout\/application.slim/
          render_multiple_file
        elsif slim_path =~ /template\/post.slim/
          render_multiple_file(:post)
        else
          $routes.each do |route_data|
            if route_data[:view].is_a?(String)
              if slim_path == "#{route_data[:view]}.slim"
                render(route_data, path)
              end
            else route_data[:view].is_a?(Regexp)
              if route_data[:view].match(slim_path)
                render(route_data, path)
              end
            end
          end
        end
      end
    end

    def render_multiple_file(target = :all)
      if target == :all
        $routes.each do |route_data|
          if route_data[:view].is_a?(String)
            render(route_data, "src/slim/#{route_data[:view]}.slim")
          else route_data[:view].is_a?(Regexp)
            # TODO: handle the regex path
=begin
            if route_data[:view].match?(slim_path)
              render(route_data, path)
            end
=end
          end
        end
        render_all_posts
      elsif target == :post
        render_all_posts
      end
    end

    def render_all_posts
      render_slim_file(Dir["#{@root_path}/src/slim/posts/*.slim"])
    end
  end
end

guard 'render-slim-guard' do
  watch(%r{/.*\.slim$})
end

module ::Guard
  class ParsePostGuard < ::Guard::Plugin
    def initialize(options = {})
      @root_path = Pathname.new(File.dirname(__FILE__))
      super
    end

    def run_all
      parse_all_posts
    end

    def run_on_changes(paths)
      parse_all_posts
    end

    def run_on_modifications(paths)
      parse_all_posts
    end

    def run_on_addititions(paths)
      parse_all_posts
    end

    private

    def parse_all_posts
      output_dir = "#{@root_path}/temp/js/app/consts"
      unless File.directory?(output_dir)
        FileUtils.mkdir_p(output_dir)
      end

      post_file = File.open("#{output_dir}/posts.js","w")
      post_file.write("POST_DATA = {")

      ts = TagService.new($tags)
      cts = TagService.new($categories)

      Dir["#{@root_path}/src/slim/posts/*.slim"].each do |post_slim|
        meta = MetaService.parse_meta(post_slim)
        post_file.write("\"#{meta["file"]}\": #{meta.to_json},")
        next if meta["draft"]
        # handle categories
        if ca = meta["category"]
          cts.add(ca)
        end
        # handle tags
        meta["tags"].each do |tag|
          ts.add(tag)
        end
      end

      File.open("#{output_dir}/categories.js","w") do |f|
        f.write("CATEGORY_DATA = ")
        f.write("#{cts.tags.to_json}")
        f.write(";")
      end
      $logger.info("#{name}/#{__method__}: update:\n  #{output_dir}/categories.js".light_magenta)

      File.open("#{output_dir}/tags.js","w") do |f|
        f.write("TAG_DATA = ")
        f.write("#{ts.tags.to_json}")
        f.write(";")
      end
      $logger.info("#{name}/#{__method__}: update:\n  #{output_dir}/tags.js".light_magenta)

      post_file.write("};")
      post_file.close
      $logger.info("#{name}/#{__method__}: update:\n  #{output_dir}/posts.js".light_magenta)
    end
  end
end

guard 'parse-post-guard' do
  watch(%r{^src/slim/posts/(.+\.slim)$})
end

module ::Guard
  class MergeJsGuard < ::Guard::Plugin
    def initialize(options = {})
      @root_path = Pathname.new(File.dirname(__FILE__))
      super
    end

    def run_all
      merge_js
    end

    def run_on_changes(paths)
      merge_js
    end

    def run_on_modifications(paths)
      merge_js
    end

    def run_on_addititions(paths)
      merge_js
    end

    private

    def merge_js
      output_dir = "#{@root_path}/temp/js"
      unless File.directory?(output_dir)
        FileUtils.mkdir_p(output_dir)
      end
      File.open("#{output_dir}/app.js","w") do |f|
        # merge const js first
        Dir["#{output_dir}/app/consts/**/*.js"].each do |src_file|
          f.write(File.read(src_file))
        end
        # merge app js
        if File.file?("#{output_dir}/app/app.js")
          File.open("#{output_dir}/app/app.js","r") do |src_file|
            f.write(File.read(src_file))
          end
        end
        # merge services, directives, controllers js in order
        folders = ["services", "directives", "controllers"]
        folders.each do |fd|
          Dir["#{output_dir}/app/#{fd}/*.js"].each do |src_file|
            f.write(File.read(src_file))
          end
        end
      end
      build_js_dir = "#{@root_path}/build/js"
      File.open("#{build_js_dir}/app.min.js", "w") do |f|
        f.write(Uglifier.compile(File.read("#{output_dir}/app.js")))
      end
      # for js debug
      system("cp #{output_dir}/app.js #{build_js_dir}/app.js")
      $logger.info("#{name}/#{__method__}: update:\n  #{build_js_dir}/app.js".light_blue)
    end
  end
end

guard 'merge-js-guard' do
  # only watch temp/js/app/*.js and skip temp/js/app.js
  watch(%r{^temp/js/.+/(.+\.js)$})
end
