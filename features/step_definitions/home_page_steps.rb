Given(/^user opens the BCA portal in web-browser$/) do
  step 'user with role Regular user opens the BCA portal in web-browser'
end

Given(/^user with role (.*) opens the BCA portal in web\-browser$/) do |user_role|
  environment = get_current_environment
  step "#{user_role} opens on #{environment} and login into BCA portal"
end

Given(/^(.*) opens on ([^"]*) and login into BCA portal$/) do |user_role, environment|
  env_config = get_env_data(environment)
  user_role = user_role.downcase
  Capybara.app_host = env_config['host']
  login_data = {
      host: Capybara.app_host,
      username: env_config[user_role]['user_name'],
      password: env_config[user_role]['user_password']
  }
  @portal_login_data = login_data
  @session.visit Capybara.app_host
  sleep(1)
  user = "#{env_config['domain']}#{login_data[:username]}"
  login_page = ADFSLoginPage.new
  if ENV['BROWSER'] == 'IE'
    if alert_present?
      login_in_model_window(user, login_data[:password])
    else
      if login_page.has_adfs_deloitte_logo_el?
        if login_page.has_accounts_form?
          login_page.open_login_form(environment)
        end
        login_in_model_window(user, password)
      end
    end
  else
    if login_page.has_adfs_deloitte_logo_el?
      if login_page.has_accounts_form?
        login_page.open_login_form(environment)
      end
      sleep(1)
      login_page.login("#{user}", login_data[:password])
    end
  end
  expect(@session).to have_css('.btn.btn-primary'), 'Login is failed'
end

When(/^user creates a new project with such parameters from Home page:$/) do |table|
  # table is a table.hashes.keys # => [:project_name, :transform_type, :start_date, :end_date, :confidential, :client_name, :base_year, :business_case]
  home_page = HomePage.new
  @project_objects = ProjectObjects.new
  table.hashes.each do |row|
    row[:project_name] = (row[:project_name].eql? 'auto') ? generate_project_name : row[:project_name]
    @project_objects.project_name = row[:project_name]
    home_page.create_project(row)
  end
  refresh_page
end

Then(/^user verifies that new project is created and present on Home page$/) do |table|
  # table is a table.hashes.keys # => [:project_name, :transform_type, :date date, :client_name]
  home_page = HomePage.new
  table.hashes.each do |row|
    row['project_name'] = (row[:project_name].eql? 'auto') ? @project_objects.project_name : row[:project_name]
    actual_project_data = home_page.get_project_tile_data(@project_objects.project_name)
    expect(actual_project_data).to eq(row), 'Project is created with incorrect data'
  end
end

When(/^user opens created Project from Home page$/) do
  step "user opens created Project by name #{@project_objects.project_name} from Home page"
end

When(/^user opens created Project by name (.*) from Home page$/) do |project_name|
  if @project_objects.nil?
    @project_objects = ProjectObjects.new
    @project_objects.project_name = project_name
  end
  home_page = HomePage.new
  home_page.open_project(project_name)
end

And(/^user opens first project from Home page$/) do
  home_page = HomePage.new
  home_page.open_first_project
end

And(/^user removes just created project$/) do
  home_page = HomePage.new
  project_name = @project_objects.project_name
  home_page.remove_project(project_name)
  expect(home_page.find_tile(project_name)).to be(nil)
end