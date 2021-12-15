class YammerClient < OAuth2Client::Client
  def initialize(*args)
    super
    @token_path     = '/oauth2/token'
    @authorize_path = '/dialog/oauth/authorize'
  end

  # Generates the Yammer URL that the user will be redirected to in order to
  # authorize your application
  #
  # @see https://developer.yammer.com/api/oauth2.html#client-side
  #
  # @opts [Hash] additional parameters to be include in URL eg. scope, state, etc
  #
  # client = YammerClient.new(config)
  # client.clientside_authorization_url({
  #      :redirect_uri => 'https://localhost/oauth/cb',
  #    })
  # >> https://www.yammer.com/dialog/oauth/?client_id={client_id}&
  #    redirect_uri=http%3A%2F%2Flocalhost%2Foauth%2Fcb&response_type=token
  #
  def clientside_authorization_url(opts = {})
    implicit.token_url(opts)
  end

  # Generates the Yammer URL that the user will be redirected to in order to
  # authorize your application
  #
  # @see https://developer.yammer.com/api/oauth2.html#server-side
  #
  # @opts [Hash] additional parameters to be include in URL eg. scope, state, etc
  #
  # >> client = YammerClient.new(config)
  # >> client.webserver_authorization_url({
  #      :redirect_uri => 'https://localhost/oauth/cb',
  #    })
  # >> https://www.yammer.com/dialog/oauth/?client_id={client_id}&
  #    redirect_uri=http%3A%2F%2Flocalhost%2Foauth%2Fcb&response_type=code
  #
  def webserver_authorization_url(opts = {})
    opts[:scope] = normalize_scope(opts[:scope]) if opts[:scope]
    authorization_code.authorization_url(opts)
  end

  # Generates the Yammer URL that the user will be redirected to in order to
  # authorize your application
  #
  # @see https://developer.yammer.com/api/oauth2.html#server-side
  #
  # @opts [Hash] additional parameters to be include in URL eg. scope, state, etc
  #
  # >> client = YammerClient.new(config)
  # >> client.webserver_authorization_url({
  #      :client_secret => @client_secret
  #      :code => 'G3Y6jU3a',
  #      :redirect_uri => 'https://localhost/oauth/cb',
  #    })
  # >> https://www.yammer.com/oauth2/access_token?client_id={client_id}&
  #    redirect_uri=http%3A%2F%2Flocalhost%2Foauth%2Fcb&client_secret={client_secret}&
  #    grant_type=authorization_code&code=aXW2c6bYz
  #
  def webserver_token_url(opts = {})
    opts[:scope] = normalize_scope(opts[:scope]) if opts[:scope]
    opts[:client_secret] = @client_secret
    authorization_code.token_path(opts)
  end

  # Makes a request to Yammer server that will swap your authorization code for an access
  # token
  #
  # @see https://developer.yammer.com/api/oauth2.html#server-side
  #
  # @opts [Hash] must include authorization code and redirect uri in additon to others
  #
  # >> client = YammerClient.new(config)
  # >> client.exchange_auth_code_for_token({
  #      :redirect_uri => 'https://localhost:3000/oauth/v2/callback',
  #      :code => 'G3Y6jU3a',
  #    })
  #
  # POST /oauth2/access_token HTTP/1.1
  # Host: www.yammer.com
  # Content-Type: application/x-www-form-urlencoded

  #  client_id={client_id}&code=G3Y6jU3a&grant_type=authorization_code&
  #  redirect_uri=http%3A%2F%2Flocalhost%2Foauth%2Fcb&client_secret={client_secret}

  def exchange_auth_code_for_token(opts = {})
    unless opts[:params] && opts[:params][:code]
      raise ArgumentError, 'You must include an authorization code as a parameter'
    end

    opts[:authenticate] ||= :body
    code = opts[:params].delete(:code)
    authorization_code.get_token(code, opts)
  end
end
