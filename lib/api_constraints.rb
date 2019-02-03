class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    @default || regex.match?(req.headers['Accept'].to_s)
  end

  private

  def format_version
    if @version.instance_of?(Array)
      @version.join(',')
    else
      @version
    end
  end

  def regex
    Regexp.new(/application\/vnd.lists_cards_api.v[#{format_version}]\+json/)
  end
end
