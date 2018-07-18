#set general data for rest api steps
Given(/^(?:|I\s|user\s|system\s)set(?:|s) Rest Api general parameters$/) do
  environment = get_current_environment
  step "system sets Rest Api parameters on #{environment}"
end

#environments DEV|QA
Given(/^system sets BCA Rest Api general parameters on ([^"]*)$/) do |environment|
  environment = environment
  step "system sets Rest Api parameters on #{environment}"
end

Given(/^system sets Rest Api parameters on ([^"]*)$/) do |environment|
  env_config = get_env_data(environment)
  server_path = env_config['host']

  login_data = {
      username: env_config['regular user']['user_name'],
      password: env_config['regular user']['user_password'],
      server_host: server_path,
      domain: env_config['domain']
  }
  @portal_login_data = login_data
  ## data hash which share date thought other steps
  @portal_data = {}

  @adfs_http_client = BaseSender.new(host: server_path, user: "#{login_data[:domain]}#{login_data[:username]}", password: login_data[:password])
  @adfs_http_client.get_cookies
end


And(/^user removes just created project by Rest Api$/) do
   step "user removes project with title #{@project_objects.project_name} by Rest Api"
end

And(/^user removes project with title (.*) by Rest Api$/) do |title|
  @adfs_http_client.delete_project(title)
end