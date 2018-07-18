require_relative 'adfs_client'
require_relative 'headers_module'
## Base Rest Api class sender for common methods
class BaseSender < AdfsClient
  include HeadersModule

  @adfs_http_client

  def initialize(options = {})
    @user = options.fetch(:user, nil)
    @password = options.fetch(:password, nil)
    @app_url = options.fetch(:host, nil)
    @adfs_http_client = AdfsClient.new(@user, @password, true)
  end

  def delete_project(project_name)
    path = "#{@app_url}/api/projects/delete"
    project_id = get_project_id(project_name)
    body = "{projectId: #{project_id}}"
    result = @adfs_http_client.post(path, header: get_content_type, body: body)
    unless result.status == 200
      raise "Request failed with status #{result.status} for delete project #{project_name}"
    end
  end

  def get_project_id(project_name)
    path = "#{@app_url}/api/projects/get-dashboard-data"

    body = "{searchTerm: '', pageSize: 200, pageNumber: 1}"
    result = @adfs_http_client.post(path, header: get_content_type, body: body)
    unless result.status == 200
      raise "Request failed with status #{result.status} for delete project #{project_name}"
    end
    all_users_projects = JSON.parse(result.content)['projects']
    all_users_projects.find {|h| h['name'] == project_name}['id']
  end

  def delete_all_proj
    path = "#{@app_url}/api/projects/get-dashboard-data"
    path_delete = "#{@app_url}/api/projects/delete"
    all_proj_ids = Array.new
    body = "{searchTerm: '', pageSize: 200, pageNumber: 1}"
    result = @adfs_http_client.post(path, header: get_content_type, body: body)
    unless result.status == 200
      raise "Request failed with status #{result.status} for delete project #{project_name}"
    end
    all_users_projects = JSON.parse(result.content)['projects']
    all_users_projects.each do |project|
      all_proj_ids.push(project['id'])
    end
    all_proj_ids.each do |id|
      body = "{projectId: #{id}}"
      result = @adfs_http_client.post(path_delete, header: get_content_type, body: body)
      unless result.status == 200
        raise "Request failed with status #{result.status} for delete project #{project_name}"
      end
    end
  end

  def get_cookies
    @adfs_http_client.set_auth(@user, @password)
    @adfs_http_client.get(@app_url)
  end

  def save_cookies_to_hash
    get_cookies
    settings = {}
    @adfs_http_client.httpclient.cookies.each {|cookie|
      settings[cookie.name] = cookie.value
    }
    settings
  end

  def cookies_to_string(cookies = {})
    "ASP.NET_SessionId=#{cookies['ASP.NET_SessionId']}; AppSettings=#{cookies['AppSettings']}; "\
    "__RequestVerificationToken=#{cookies['__RequestVerificationToken']}; FedAuth=#{cookies['FedAuth']}; "\
    "FedAuth1=#{cookies['FedAuth1']}"
  end


end