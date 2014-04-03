node.default['securize']['ufw'] = {
  'ips_whitelist'    => %w(),
  'ports_whitelist'  => %w(22),
  'default_incoming' => "reject"
}
