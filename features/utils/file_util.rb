def get_root_project_path
  File.expand_path('../../', File.dirname(__FILE__))
end

def get_resources_file_path(file_name)
  Dir.glob("#{get_root_project_path}/**/#{file_name}").first
end
