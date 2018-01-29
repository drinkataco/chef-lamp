package 'unzip'
package 'git'
package 'libapache2-mod-fastcgi'

#
# Create default directories
#
# Web directory
directory "#{node['app']['web_dir']}/#{node['app']['site_name']}" do
end

# Log Directory
directory "#{node['app']['log_dir']}/#{node['app']['site_name']}" do
  owner node['user']['name']
  mode "0755"
  recursive true
end

#
# Grab database details if they exit. This is to pass to the vhost where they can
# be set as apache variables
#
db_user = ''
db_password = ''
begin
  mariadb_data_bag = data_bag_item('database', 'mariadb')
  db_user = mariadb_data_bag['username']
  db_password = mariadb_data_bag['password']
rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
end

#
# Enable virtual host
#
template "#{node['apache']['dir']}/sites-available/#{node['app']['site_name']}.conf" do
  source node['app']['vhost_filename']
  mode "0777"
  variables ({
    :db_user => db_user,
    :db_password => db_password
  })
end

# Enable vhost and fpm mod
node.default['apache']['default_site_enabled'] = false
apache_site "#{node['app']['name']}.conf", true

execute 'site_enable' do
  command "a2ensite #{node['app']['site_name']};" \
    "a2enmod proxy_fcgi;" \
    "service apache2 restart"
end;

#
# Set up default site
#
begin
  sc_data_bag = data_bag_item('git', "remote")

  # TODO: Check not already cloned

  unless sc_data_bag['username'].to_s.strip.empty?
    execute 'initialise_git' do
      command "git config --global user.name #{sc_data_bag['username']}"
    end
  end

  password = ''

  unless sc_data_bag['password'].to_s.strip.empty?
    password = ":#{sc_data_bag['password']}"
  end

  fetch_cmd = "git clone https://#{sc_data_bag['username']}#{password}#{sc_data_bag['location']} #{node['app']['web_dir']}"
rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
  puts 'No databag for Git. Nothing cloned.'
  puts 'Placing default index file'

  cookbook_file "#{node['app']['web_dir']}/#{node['app']['site_name']}/index.php" do
    source "index.php"
  end
end