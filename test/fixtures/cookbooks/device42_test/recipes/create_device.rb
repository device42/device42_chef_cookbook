url = node['device42']['instance']
user = node['device42']['user']
password = node['device42']['password']

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

device 'create an asset' do
  device_name node['hostname']
  user user
  password password
  url url
end
