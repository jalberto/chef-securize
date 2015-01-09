node.default['securize']['deploy_user'] = 'deploy'
node.default['securize']['ufw'] = {
  'ips_whitelist'    => [],
  'ports_whitelist'  => %w(22),
  'default_incoming' => "reject"
}
node.default['securize']['sshkeys'] = {
  'gh_url'   => 'https://github.com',
  'gh_users' => %w()
}
