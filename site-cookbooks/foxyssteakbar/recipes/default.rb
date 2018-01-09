#
# PHP Modules
#
package 'php7.0-curl'
package 'php7.0-mbstring'
package 'php7.0-gd'
package 'php7.0-pdo'

#
# Build database
#
mariadb_data_bag = data_bag_item('database', 'mariadb')

# TODO: load from SQL file, if SQL file

execute 'environment_variables' do
  command "export SYMFONY__DATABASE__USER=#{mariadb_data_bag['username']};" \
    "export SYMFONY__DATABASE__PASSWORD=#{mariadb_data_bag['password']};" \
    "/var/www/foxyssteakbar-site/bin/adminconsole sulu:build dev -n"
end

#
# Enable mod rewrite
#
execute 'enable_mod_rewrite' do
  command "sudo a2enmod rewrite; sudo service apache2 restart"
end