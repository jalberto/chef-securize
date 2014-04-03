packages = %w(denyhosts)
packages.each do |pkg|
  package pkg do
    action :install
    ignore_failure true
  end
end

node['securirze']['ufw']['ips_whitelist'].each do |ip|
  bash "Add safe IPs hosts.allow" do
    code <<-EOF
    echo "sshd: #{ip} >> /etc/hosts.allow"
    EOF
  end
end
