## sets db configuration and create data base client object for use in other steps
Given(/^system connect to sql data base$/) do
  environment = get_current_environment
  env_config = get_env_data(environment)
  db_config = env_config['data_base']
  db_options = {username: db_config['user'],
                password: db_config['password'],
                host: db_config['server_host'],
                database: db_config['data_base']}
  @db_client = connect_to_db(db_options)
end

When(/^user deletes a project with name (.*) from data base$/) do |project_title|
  sql_query = "should be query with project delete by project title"
  execute_sql_query(@db_client, sql_query)
end

## delete auto generated project
When(/^user deletes a auto created project from data base$/) do
  step "user deletes a project with name #{@project_objects.project_name} from data base"
end