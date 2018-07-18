require 'yaml'

def get_current_environment
  ENV['TEST_ENV'] ||= 'QA'
end

#yml is parsed into hash table, than basing on env passed a block is taken
def get_env_data(env)
  config_path = "#{File.expand_path("../../", __FILE__).gsub('features', '')}config/config.yml"
  yml = YAML::load(File.read(config_path))
  yml[env.downcase]
end
