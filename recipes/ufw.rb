package 'ufw' do
  action :install
  ignore_failure true
end

if node['securize']['ufw']['ports_whitelist']
  node["securize"]["ufw"]["ports_whitelist"].each do |port|
    execute "UFW open port #{port}" do
      command "ufw allow #{port}"
      action :run
    end
  end
end

if node['securize']['ufw']['ips_whitelist']
  node["securize"]["ufw"]["ips_whitelist"].each do |port|
    execute "UFW allow IP #{ip}" do
      command "ufw allow from #{ip}"
      action :run
    end
  end
end

if node['securize']['ufw']['block_ports']
  node['securize']['ufw']['block_ports'].each do |port|
    execute "UFW block port #{port}" do
      command "ufw deny #{port}"
      action :run
    end
  end
end

unless node[:instance_role] == 'vagrant'
  execute 'UFW default incoming policy' do
    command "ufw default #{node['securize']['ufw']['default_incoming']} incoming"
    action :run
  end
  execute 'UFW logging' do
    command "ufw logging on"
    action :run
  end
  execute 'UFW enabe' do
    command "ufw enable"
    action :run
  end
end
