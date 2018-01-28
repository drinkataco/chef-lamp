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
package 'libapache2-mod-php7.1'

# Reload Apache
execute 'restart_apache' do
  command "sudo service apache2 restart;"
end




# php7.1-xml
# php7.1-xsl
# php7.1-mbstring
# php7.1-readline
# php7.1-zip
# php7.1-mysql
# php7.1-phpdbg
# php7.1-interbase
# php7.1-sybase
# php7.1
# php7.1-sqlite3
# php7.1-tidy
# php7.1-opcache
# php7.1-pspell
# php7.1-json
# php7.1-xmlrpc
# php7.1-curl
# php7.1-ldap
# php7.1-bz2
# php7.1-cgi
# php7.1-imap
# php7.1-cli
# php7.1-dba
# php7.1-dev
# php7.1-intl
# php7.1-fpm
# php7.1-recode
# php7.1-odbc
# php7.1-gmp
# php7.1-common
# php7.1-pgsql
# php7.1-bcmath
# php7.1-snmp
# php7.1-soap
# php7.1-mcrypt
# php7.1-gd
# php7.1-enchant
# libapache2-mod-php7.1