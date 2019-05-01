url = node['device42']['instance']
user = node['device42']['user']
password = node['device42']['password']

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

ip = IPAM.new(url, user, password).suggest_ip('10.90.0.0/16')
puts ip

reserved = IPAM.new(url, user, password).reserve_ip(ip)
puts reserved
