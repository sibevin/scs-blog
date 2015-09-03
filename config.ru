require './config/app.rb'

module Rack
  class ScsBlog < Static
    def call(env)
      status, headers, response = @file_server.call(env)
      if status == 404
        ori_path = env["PATH_INFO"]
        if ori_path == "/"
          env["PATH_INFO"] = "index.html"
        else
          env["PATH_INFO"] = "#{ori_path}.html"
          status, headers, response = @file_server.call(env)
          if status == 404
            env["PATH_INFO"] = "#{ori_path}/index.html"
            status, headers, response = @file_server.call(env)
            env["PATH_INFO"] = App::ERROR_404_PATH if status == 404
          end
        end
      end
      super
    end
  end
end

use Rack::ScsBlog,
  :urls => [""],
  :root => "build",
  :index => 'index.html'

run lambda { |env|
  [
    200,
    {
      'Content-Type'  => 'text/html',
      'Cache-Control' => 'public, max-age=86400'
    },
    File.open('build/index.html', File::RDONLY)
  ]
}
