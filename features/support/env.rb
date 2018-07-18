require 'selenium/webdriver'
require 'capybara/rspec/matchers'
require 'capybara/dsl'
require 'capybara'
require 'site_prism'
require 'parallel_tests'
require 'json'

World(Capybara::RSpecMatchers)

REPORTS_PATH = 'reports'
FileUtils.mkdir_p(REPORTS_PATH) unless File.exist?(REPORTS_PATH)
FileUtils.rm_f Dir.glob("#{REPORTS_PATH}/*") if File.exists?("#{REPORTS_PATH}/")

SERVER_PORT = 10000 + ENV['TEST_ENV_NUMBER'].to_i
Capybara.server_port = SERVER_PORT