module OAuth2Client
  class Client
    attr_reader   :host, :connection_options
    attr_accessor :client_id, :client_secret, :connection_client,
                  :authorize_path, :token_path, :device_path

    DEFAULTS_PATHS = {
      authorize_path: '/oauth2/authorize',
      token_path: '/oauth2/token',
      device_path: '/oauth2/device/code'
    }

    def initialize(host, client_id, client_secret, options = {})
      @host               = host
      @client_id          = client_id
      @client_secret      = client_secret
      @connection_options = options.fetch(:connection_options, {})
      @connection_client  = options.fetch(:connection_client, OAuth2Client::HttpConnection)
      DEFAULTS_PATHS.keys.each do |key|
        instance_variable_set(:"@#{key}", options.fetch(key, DEFAULTS_PATHS[key]))
      end
    end

    def host=(hostname)
      @connection = nil
      @host = hostname
    end

    def connection_options=(options)
      @connection = nil
      @connection_options = options
    end

    # Token scope definitions vary by service e.g Google uses space delimited scopes,
    # while Github uses comma seperated scopes. This method allows us to normalize
    # the token scopes
    #
    # @see http://developer.github.com/v3/oauth/#scopes, https://developers.google.com/accounts/docs/OAuth2WebServer#formingtheurl
    def normalize_scope(scope, sep = ' ')
      unless scope.is_a?(String) || scope.is_a?(Array)
        raise ArgumentError, "Expected scope of type String or Array but was: #{scope.class.name}"
      end

      (scope.is_a?(Array) && scope.join(sep)) || scope
    end

    def implicit
      OAuth2Client::Grant::Implicit.new(self)
    end

    def authorization_code
      OAuth2Client::Grant::AuthorizationCode.new(self)
    end

    def refresh_token
      OAuth2Client::Grant::RefreshToken.new(self)
    end

    def client_credentials
      OAuth2Client::Grant::ClientCredentials.new(self)
    end

    def password
      OAuth2Client::Grant::Password.new(self)
    end

    def device_code
      OAuth2Client::Grant::DeviceCode.new(self)
    end

    def connection
      @connection ||= @connection_client.new(@host, @connection_options)
    end
  end
end
