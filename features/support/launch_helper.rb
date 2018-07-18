#relative path to reports

ENV['SCREENSHOT_PATH'] = 'reports/'

#Hooks
AfterConfiguration do |config|
  puts "Features in #{config.feature_dirs}"
end

if ENV['BROWSER'] == 'CHROME'
#Hooks Before and After to launch and stop web driver
  Before do
    Capybara.register_driver :chrome do |app|
      options = Selenium::WebDriver::Chrome::Options.new
      prefs = {'download.default_directory': DownloadHelper::DOWNLOADS_PATH.to_s}
      options.add_option('prefs', prefs)
      options.add_argument('--disable-infobars')
      options.add_argument('--window-size=1400,900')
      Capybara::Selenium::Driver.new(app, :browser => :chrome, options: options)
    end

    Capybara.save_path = REPORTS_PATH
    Capybara.javascript_driver = :chrome
    Capybara.current_driver = :chrome
    set_default_capybara_options

  end

elsif ENV['BROWSER'] == 'IE'

  Before do
    Capybara.register_driver :internet_explorer do |app|
      options = Selenium::WebDriver::IE::Options.new
      options.add_option(:ignore_protected_mode_settings, true)
      Capybara::Selenium::Driver.new(app, :browser => :internet_explorer, options: options)
    end
    Capybara.javascript_driver = :internet_explorer
    Capybara.current_driver = :internet_explorer
    set_default_capybara_options
    @session.driver.browser.manage.window.maximize
  end
end

After do |scenario|
  if scenario.failed?
    p " SCENARIO HAS FAILED !!!!!!!!!!!!!!!!!!!!"
    puts scenario

    screenshot_path = @session.save_screenshot
    filename = File.basename(screenshot_path)
    embed(screenshot_path, 'image/png', filename)
  end
  Capybara.reset_sessions!
end

#Utility methods
def ui_browser?
  [:selenium, :chrome, :internet_explorer].include?(Capybara.current_driver)
end

def set_cookie(cookie_name, cookie_value, options)
  if ui_browser?
    #@session.driver.browser.manage.add_cookie(:name => cookie_name, :value => cookie_value, host: domain, path: path  )
    @session.driver.browser.manage.add_cookie({name: cookie_name, value: cookie_value}.merge(options))
  end
end

def set_default_capybara_options
  Capybara.save_path = REPORTS_PATH
  Capybara.default_max_wait_time = 5
  Capybara.wait_on_first_by_default = true
  @session = Capybara.current_session
  if ui_browser?
    @session.driver.browser.manage.delete_all_cookies
  end
end

def cleanup_reports_folder
  FileUtils::rm_r REPORTS_PATH if File.exist?(REPORTS_PATH)
  FileUtils::mkpath REPORTS_PATH
end

def cleanup_reports_for_parallel
  FileUtils.rm_f Dir.glob("#{REPORTS_PATH}/*") if File.exist?(REPORTS_PATH)
end
