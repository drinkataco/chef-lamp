# Web Directory
directory "#{node['app']['web_dir']}/#{node['app']['site_name']}" do
  owner node['user']['name']
	group node['user']['name']
	mode "0755"
	recursive true
end

# Log Directory
directory "#{node['app']['log_dir']}/#{node['app']['site_name']}" do
  owner node['user']['name']
  mode "0755"
  recursive true
end

# Web files
template "#{node['apache']['dir']}/sites-available/#{node['app']['site_name']}.conf" do
  source "apache2.template.conf.erb" # @TODO make me configurable
  mode "0777"
end

# Enable vhost
node.default['apache']['default_site_enabled'] = false
apache_site "#{node['app']['name']}.conf", true

execute 'site_enable' do
  command "a2ensite #{node['app']['site_name']}"
end;

# TODO: Move to foxyssteakbar cookbook
# Fetch reposity

# Install with composer

# Set up with database

# Fix permissions
# HTTPDUSER=`ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`
# sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX var/cache var/logs var/uploads var/uploads/* web/uploads web/uploads/* var/indexes var/sessions
# sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX var/cache var/logs var/uploads var/uploads/* web/uploads web/uploads/* var/indexes var/sessions