# Set default root password
node.default['mariadb']['server_root_password'] = 'test'
node.default['mariadb']['allow_root_pass_change'] = 'true'
node.default['mariadb']['forbid_remote_root'] = 'true'

# Create default admin user
mariadb_data_bag = data_bag_item('database', "mariadb")

# TODO: only create if it doesn't already exist
execute 'create_database' do
  command "mysql -e 'CREATE DATABASE IF NOT EXISTS #{mariadb_data_bag['database']}'"
end

# Create default database user
# TODO: only create if it doesn't already exist
user_sql = 'GRANT ALL PRIVILEGES ON ' + mariadb_data_bag['database'] + '.* '\
  'TO "' + mariadb_data_bag['username'] + '"@"localhost" '\
  'IDENTIFIED BY "' + mariadb_data_bag['password'] + '"'

execute 'create_database_user' do
  command "mysql -e '#{user_sql}'"
end