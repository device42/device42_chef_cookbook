include Device42::API

resource_name :device

property :device_name, String, required: true
property :user, String, required: true
property :password, String, required: true
property :url, String, required: true

default_action :create

action_class do
  def client
    Device42::API::Client.new(
      new_resource.url,
      new_resource.user,
      new_resource.password,
      nil
    )
  end
end

action :create do
  message = {}

  message[:name] = new_resource.device_name
  message[:os] = node['platform']
  message[:osver] = node['platform_version']
  message[:cpucount] = node['cpu']['total']
  message[:cpucore] = node['cpu']['0']['cores']
  message[:cpupower] = node['cpu']['0']['mhz'].to_i

  message[:macaddress] = node['macaddress']

  totalmem = 0
  case node['platform_family']
  when 'windows'
    totalmem = node['cs_info']['total_physical_memory'] || 0
    totalmem = totalmem.to_i / (1024 * 1024)
  else
    totalmem = if node['memory']['total'].end_with?('kB')
                 node['memory']['total'][0..-2].to_i / 1024
               elsif node['memory']['total'].end_with?('mB')
                 node['memory']['total'][0..-2].to_i
               elsif node['memory']['total'].end_with?('gB')
                 node['memory']['total'][0..-2].to_i * 1024
               else
                 node['totalmem']
               end
  end
  message[:memory] = totalmem

  hddcount = 0
  hddsize = 0
  node['filesystem']['by_device'].each do |_devname, dev|
    hddcount += 1
    size = dev['kb_size'].to_i / (1024 * 1024)
    hddsize += size
  end
  message[:hddcount] = hddcount
  message[:hddsize] = hddsize

  log message.map { |k, v| "#{k}=#{v}" }.join('&')

  http_request "create #{new_resource.device_name}" do
    headers client.headers
    message message.map { |k, v| "#{k}=#{v}" }.join('&')
    url ::File.join(client.url, 'api', '1.0', 'devices', '/')
    action :post
  end

  node['network']['interfaces'].each do |ifsname, ifs|
    message = {}

    next if ifsname == 'lo'

    home = ifs['addresses'].select { |k, _v| k.start_with? '127.0' }
    next unless home.empty?

    macs = ifs['addresses'].select { |_k, v| v['family'] == 'lladdr' }
    macaddr = nil
    macaddr = macs.keys[0] if macs

    ifs['addresses'].each do |nodeip, addr|
      next if addr['family'] == 'lladdr'
      next if nodeip.start_with? 'fe80'
      message[:ipaddress] = nodeip
      message[:tag] = ifsname
      message[:device] = new_resource.device_name
      message[:macaddress] = macaddr

      log message.map { |k, v| "#{k}=#{v}" }.join('&')

      http_request "create ip #{nodeip}" do
        headers client.headers
        message message.map { |k, v| "#{k}=#{v}" }.join('&')
        url ::File.join(client.url, 'api', '1.0', 'ips', '/')
        action :post
        ignore_failure :quiet
      end
    end
  end
end
