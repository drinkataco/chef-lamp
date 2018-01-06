# If databag for mariadb exists, use to create user and database
begin
  mariadb_data_bag = data_bag_item('database', 'mariadb')

  # Create default database
  execute 'create_database' do
    command "mysql -e 'CREATE DATABASE IF NOT EXISTS #{mariadb_data_bag['database']}'"
  end

  # Create default database user
  user_sql = 'GRANT ALL PRIVILEGES ON ' + mariadb_data_bag['database'] + '.* '\
    'TO "' + mariadb_data_bag['username'] + '"@"localhost" '\
    'IDENTIFIED BY "' + mariadb_data_bag['password'] + '"'

  execute 'create_database_user' do
    command "mysql -e '#{user_sql}'"
  end
rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
  puts 'No databag for Mariadb'
  puts 'Configuration for mariadb remains as default'
end