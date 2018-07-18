class AdfsClient
  require 'httpclient'
  require 'openssl'
  require 'nokogiri'

  @http_client
  @username
  @password

  def initialize(*args, &block)
    @http_client = HTTPClient.new
    @username, @password, skip_check = keyword_argument(args, :username, :password, :skip_check)
    if skip_check
      @http_client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    instance_eval(&block) if block
  end

  def httpclient
    @http_client
  end

  def httpclient=(client)
    @http_client = client
  end

  def set_auth(username, password)
    @username = username
    @password = password
  end

  def get(uri, *args, &block)
    query, header, follow_redirect = keyword_argument(args, :query, :header, :follow_redirect)
    response = @http_client.get(uri, query, header, follow_redirect, &block)
    if response.status == 302
      #puts 'Starting authentication'
      authenticate(response)
      response = @http_client.get(uri, query, header, follow_redirect, &block)
    end
    response
  end

  def get_cookies_request(uri,*args, &block)
    query, header, follow_redirect = keyword_argument(args, :query, :header, :follow_redirect)
    authenticate(@http_client.get(uri, query, header, follow_redirect, &block))
  end

  def post(uri, *args, &block)
    if hashy_argument_has_keys(args, :query, :body)
      query, body = keyword_argument(args, :query, :body)
      response = @http_client.post(uri, query, body, &block)
      if response.status == 302
        #puts 'Starting authentication'
        authenticate(response)
        response = @http_client.post(uri, query, body, &block)
      end
      response
    else
      body, header, follow_redirect = keyword_argument(args, :body, :header, :follow_redirect)
      response = @http_client.post(uri, body, header, follow_redirect, &block)
      if response.status == 302
        #puts 'Starting authentication'
        authenticate(response)
        response = @http_client.post(uri, body, header, follow_redirect, &block)
      end
      response
    end
  end

  # Sends PUT request to the specified URL.  See request for arguments.
  def put(uri, *args, &block)
    if hashy_argument_has_keys(args, :query, :body)
      query, body = keyword_argument(args, :query, :body)
      response = @http_client.put(uri, query, body, &block)
      if response.status == 302
        #puts 'Starting authentication'
        authenticate(response)
        response = @http_client.put(uri, query, body, &block)
      end
      response
    else
      body, header = keyword_argument(args, :body, :header)
      response = @http_client.put(uri, body, header, &block)
      if response.status == 302
        #puts 'Starting authentication'
        authenticate(response)
        response = @http_client.put(uri, body, header, &block)
      end
      response
    end
  end

  # Sends DELETE request to the specified URL.  See request for arguments.
  def delete(uri, *args, &block)
    query, header, body = keyword_argument(args, :query, :header, :body)
    response = @http_client.delete(uri, query, header, body, &block)
    if response.status == 302
      #puts 'Starting authentication'
      authenticate(response)
      response = @http_client.delete(uri, query, header, body, &block)
    end
    response
  end

  private def authenticate(response)

    is_old_auth = false
    newuri = response.header['Location'].first
    #puts "Get realm form at: #{newuri}"
    response_client = @http_client.get(newuri)
    doc = Nokogiri::HTML.parse(response_client.content)

    action = doc.xpath('//form[@id="hrd"]/@action')
    auth_response = nil
    if action.count == 0
      # Perform old authentication
      is_old_auth = true
      #puts response_client.content
      action = doc.xpath('//form[@id="aspnetForm"]/@action')
      viewstate = doc.xpath('//input[@id="__VIEWSTATE"]/@value')
      eventvalidation = doc.xpath('//input[@id="__EVENTVALIDATION"]/@value')
      submit = doc.xpath('//input[@id="ctl00_ContentPlaceHolder1_PassiveSignInButton"]/@value')
      auth_uri = URI.parse(newuri.to_s); auth_uri.path = ''; auth_uri.query = nil; auth_uri.to_s

      posturi = auth_uri.to_s + action.to_s
      #puts "Auth form post to #{posturi}"

      #@http_client.NTLMEnabled = true
      @http_client.set_auth(nil, @username, @password)
      auth_response = @http_client.post(posturi, {'__VIEWSTATE' => viewstate, '__EVENTVALIDATION' => eventvalidation,
                                                  'ctl00$ContentPlaceHolder1$PassiveSignInButton' => submit, 'ctl00$ContentPlaceHolder1$PassiveIdentityProvidersDropDownList' => '',
                                                  '__db' => 14},
                                        {'Content-Type' => 'application/x-www-form-urlencoded'})
    else
      realm = 'AD AUTHORITY'

      auth_uri = URI.parse(newuri.to_s); auth_uri.path = ''; auth_uri.query = nil; auth_uri.to_s

      posturi = auth_uri.to_s + action.to_s
      #puts "Realm form post to #{posturi}"

      auth_response = @http_client.post(posturi, {'HomeRealmSelection' => realm, 'Email' => ''},
                                        {'Content-Type' => 'application/x-www-form-urlencoded'})
    end

    if auth_response.status == 302
      token_uri = auth_response.header['Location'].first

      if !is_old_auth
        #puts "Realm form redirect to #{token_uri}"
        auth_response = @http_client.get(token_uri)
        doc = Nokogiri::HTML.parse(auth_response.content)

        action = doc.xpath('//form[@id="options"]/@action')

        posturi = action.to_s

        #puts "Password form post to #{posturi}"
        auth_response = @http_client.post(posturi, {'UserName' => @username, 'Password' => @password,
                                                    'AuthMethod' => 'FormsAuthentication'},
                                          {'Content-Type' => 'application/x-www-form-urlencoded'})
        if auth_response.status == 302
          token_uri = auth_response.header['Location'].first
          #puts "Pass form redirect to #{token_uri}"
          auth_response = @http_client.get(token_uri)
        end
      else
        token_uri = auth_uri.to_s + token_uri.to_s
        #puts "Authenticate form redirect to #{token_uri}"

        auth_response = @http_client.get(token_uri)
      end

      doc = Nokogiri::HTML.parse(auth_response.content)

      action = doc.xpath('//form[@name="hiddenform"]/@action')
      wa = doc.xpath('//input[@name="wa"]/@value')
      wresult = doc.xpath('//input[@name="wresult"]/@value')
      wctx = doc.xpath('//input[@name="wctx"]/@value')

      #puts "Token server post to #{action}"
      @http_client.post(action, {'wa' => wa, 'wresult' => wresult,
                                 'wctx' => wctx},
                        {'Content-Type' => 'application/x-www-form-urlencoded'})
    end
  end

  private def keyword_argument(args, *field)
    if args.size == 1 and Hash === args[0]
      h = args[0]
      if field.any? {|f| h.key?(f)}
        return h.values_at(*field)
      end
    end
    args
  end

  private def hashy_argument_has_keys(args, *key)
    # if the given arg is a single Hash and...
    args.size == 1 and Hash === args[0] and
        # it has any one of the key
        key.all? {|e| args[0].key?(e)}
  end
end
