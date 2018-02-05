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
mariadb_data_bag = data_bag_item('database', 'mariadb')
twilio_databag = data_bag_item('twilio', 'api')
template "#{node['app']['web_dir']}/#{node['app']['site_name']}/.env" do
  source 'env.erb'
  mode "0777"
  variables ({
    :db_user => mariadb_data_bag['username'],
    :db_password => mariadb_data_bag['password'],
    :db_database => mariadb_data_bag['database'],
    :secret_key => 'test123',
    :twilio_sid => twilio_databag['sid'],
    :twilio_token => twilio_databag['token'],
    :twilio_from_number => twilio_databag['from_number']
  })
end

#
# Set up symfony environments
#
execute 'node_install' do
  command "cd #{node['app']['web_dir']}/#{node['app']['site_name']};" \
  "yarn install --ignore-scripts; yarn build-#{ node['app']['mode'] };" \
  "composer install;"
end

#
# Set up database
#
execute 'doctrine_build' do
  command "cd #{node['app']['web_dir']}/#{node['app']['site_name']};" \
  "php bin/console doctrine:migrations:migrate;"
end
