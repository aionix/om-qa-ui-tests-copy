#require 'tiny_tds'

def connect_to_db(options)
  TinyTds::Client.new(options)
end

## execute sql query
def execute_sql_query(db_client, sql_query)
  db_client.execute(sql_query)
end

# example for getting data from table
# return data as array
def get_table_data(db_client, table_name)
  data = Array.new
  query = "select * from #{table_name}"
  result = db_client.execute(query)
  result.each do |row|
    data.push(row)
  end
  data
end

