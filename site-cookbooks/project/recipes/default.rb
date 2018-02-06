# Fix apache cause of chef bug
execute 'fix_port' do
  command "sudo sh -c \"echo 'Listen 80' >> /etc/apache2/ports.conf;\""
end

# Add PHP 7.1 Repo
execute 'php7_1_repo' do
  command "sudo apt-get install -y python-software-properties;" \
    "sudo add-apt-repository -y ppa:ondrej/php;" \
    "sudo apt-get update -y"
end

# Install PHP 7.1 packages
package 'php7.1'
package 'php7.1-mbstring'
package 'php7.1-mcrypt'
package 'php7.1-xml'
package 'php7.1-curl'
package 'php7.1-mysql'
package 'php7.1-bcmath'
package 'php7.1-amqp'
package 'libapache2-mod-php7.1'

# Reload Apache
execute 'restart_apache' do
  command "sudo service apache2 restart;"
end

# Install node and yarn
execute 'node_install' do
  command "curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -;" \
    "sudo apt-get install -y nodejs"
end

execute 'yarn_install' do
  command "curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -;" \
    "echo \"deb https://dl.yarnpkg.com/debian/ stable main\" | sudo tee /etc/apt/sources.list.d/yarn.list;" \
    "sudo apt-get update && sudo apt-get install yarn"
end

#
# Set up symfony environment variables
#
# Attempt to get the twilio databag
twilio_databag = []
begin
  twilio_databag = data_bag_item('twilio', 'api')
rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
end

mariadb_data_bag = data_bag_item('database', 'mariadb')
template "#{node['app']['web_dir']}/#{node['app']['site_name']}/.env" do
  source 'env.erb'
  mode "0777"
  variables ({
    :db_user => mariadb_data_bag['username'],
    :db_password => mariadb_data_bag['password'],
    :db_database => mariadb_data_bag['database'],
    :secret_key => 'test123',
    :twilio => twilio_databag
  })
end

#
# Set up symfony environments
#
execute 'node_yarn_install' do
  command "cd #{node['app']['web_dir']}/#{node['app']['site_name']};" \
  "yarn install && yarn build-#{ node['app']['mode'] }"
end

execute 'composer_install' do
  command "cd #{node['app']['web_dir']}/#{node['app']['site_name']};" \
  "export COMPOSER_ALLOW_SUPERUSER=1;" \
  "composer install --no-interaction;"
end

#
# Set up database
#
execute 'doctrine_build' do
  command "cd #{node['app']['web_dir']}/#{node['app']['site_name']};" \
  "php bin/console doctrine:migrations:migrate;"
end

#
# Also, lets enable mod_rewrite
#
execute 'mod_rewrite' do
  command "a2enmod rewrite; service apache2 restart;"
end;

#
# And set up a background process to monitor rabbitmq queue
#
package 'tmux'
execute 'tmux' do
  command "tmux new -d -s rabbitmq 'php #{node['app']['web_dir']}/#{node['app']['site_name']}/bin/console rabbitmq:consumer -w send_message';"
end
