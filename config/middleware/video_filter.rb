class VideoFilter
  def initialize(app)
    @app = app
  end

  def call(env)
    @status, @headers, @body = @app.call(env)
    if env['PATH_INFO'] =~ /.*\.mov$/
      @headers['Content-Disposition'] = 'attachment'
    end
    [@status, @headers, @body]
  end
end
