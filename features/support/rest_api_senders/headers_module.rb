## module to store headers
module HeadersModule

  def get_content_type_with_cookies(cookies)
    {'Content-Type': 'application/json; charset=utf-8', 'Cookie': cookies}
  end

  def get_content_type
    {'Content-Type': 'application/json; charset=utf-8'}
  end

end