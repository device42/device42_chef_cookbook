include Device42::API

class IPAM
  def initialize(url, user, password)
    @url = url
    @user = user
    @password = password
  end

  def suggest_ip(subnet)
    client = Client.new(@url, @user, @password, ['suggest_ip', "?subnet=#{subnet}"])
    Get.new(client).response['ip']
  end

  def reserve_ip(ip)
    client = Client.new(@url, @user, @password, ['ips/'])
    Post.new(client).response("ipaddress=#{ip}&tag=chefreserved")
  end
end

Chef::Recipe.include Device42
Chef::Resource.include Device42
