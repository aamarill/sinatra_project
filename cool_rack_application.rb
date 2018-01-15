require "rack"

class CoolRackApplication
  def call(env)
    http_verb = env["REQUEST_METHOD"]
    status = 200
    headers = {}
    body = ["got #{http_verb} request\n"]

    [status, headers, body]
  end
end

# Use this to run on WEBrick which is installed with Ruby by default
# Rack::Handler::WEBrick.run(CoolRackApplication.new, Port: 9292)

# To run using Puma server instead
# require "rack/handler/puma"
# Rack::Handler::Puma.run(CoolRackApplication.new, Port: 9292)

class PatchBlockingMiddleware

  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    if request.patch?
      [405, {}, ["PATCH requests not allowed! \n"]]
    else
      @app.call(env)
    end
  end
end


app = Rack::Builder.new do
  use PatchBlockingMiddleware
  run CoolRackApplication.new
end

Rack::Handler::WEBrick.run(app, Port: 9292)
