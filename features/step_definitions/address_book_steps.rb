
Given(/^user opens address book in web\-browser$/) do
  step "user with role Regular user opens the address_book portal in web-browser"
end

Given(/^user with role (.*) opens the address_book portal in web\-browser$/) do |user_role|
  environment = get_current_environment
  step "#{user_role} opens on #{environment} and login into address_book portal"
end

Given(/^(.*) opens on ([^"]*) and login into address_book portal$/) do |user_role, environment|
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
  login_page = AddressBookLoginPage.new
  if ENV['BROWSER'] == 'IE'
    if alert_present?
      login_in_model_window(user_name, login_data[:password])
    else
      if login_page.has_adfs_deloitte_logo_el?
        if login_page.has_accounts_form?
          login_page.open_login_form(environment)
        end
        login_in_model_window(user_name, password)
      end
    end
  else
    if login_page.has_address_logo_el?
      login_page.login(user, login_data[:password])
    end
  end
  expect(@session).to have_css('#logo'), 'Login is failed'
end


When(/^user creates a group with such parameters:$/) do |table|
  # table is a table.hashes.keys # => [:group_name, :group_header, :group_footer]
  address_book_page = AddressBookLoginPage.new
  address_book_page.open_groups_page
  table.hashes.each do |row|
    row[:group_name] =  row[:group_name] + generate_project_name
    address_book_page.create_group(row)

  end
end

When(/^user removes group from the list$/) do
  address_book_page = AddressBookLoginPage.new
  address_book_page.open_groups_page
  address_book_page.delete_group
end