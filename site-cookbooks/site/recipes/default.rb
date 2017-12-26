# Create default admin user
sc_data_bag = data_bag_item('git', "remote")

# Set up git
package 'git'

# TODO: might have to change as default user
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

puts '======'
puts '======'
puts '======'
puts '======'
puts '======'
puts '======'
puts '======'
puts '======'
puts '======'
puts '======'
puts fetch_cmd
puts '======'
puts '======'
puts '======'
puts '======'
puts '======'
puts '======'
