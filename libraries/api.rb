require 'base64'
require 'uri'
require 'net/http'

module Device42
  module API
    class Client
      attr_reader :url

      def initialize(url, user, password, path)
        @url = url
        @user = user
        @password = password
        @path = path
      end

      def auth
        'Basic ' + Base64.urlsafe_encode64("#{@user}:#{@password}")
      end

      def join_url
        ::File.join(@url, 'api', '1.0', @path)
      end

      def uri
        URI.parse(join_url)
      end

      def headers
        {
          'Authorization': auth,
        }
      end
    end

    class Get < Net::HTTP::Get
      def initialize(client)
        @uri = client.uri
        super @uri, client.headers
      end

      def response
        request = self

        http = Net::HTTP.new(@uri.host, @uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        response = http.start { |srv| srv.request request }
        JSON.load(response.body)
      end
    end

    class Post < Net::HTTP::Post
      def initialize(client)
        @uri = client.uri
        super @uri, client.headers
      end

      def response(body)
        request = self
        request.body = body

        http = Net::HTTP.new(@uri.host, @uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        response = http.start { |srv| srv.request request }
        JSON.load(response.body)
      end
    end
  end
end

Chef::Recipe.include Device42
Chef::Resource.include Device42
