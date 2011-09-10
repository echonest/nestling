module Nestling
  class Client
    attr_reader :api_key

    HOST = 'developer.echonest.com'
    USER_AGENT = "Nestling/#{Version::STRING}"
    DEFAULT_PARAMS = { :format => 'json' }

    def initialize(api_key = Nestling.api_key)
      @http = Net::HTTP.new(HOST)
      @api_key = api_key
      @default_params = { :api_key => api_key }.merge!(DEFAULT_PARAMS)
    end

    def artist(id)
      Nestling::Artist.new(id, self)
    end

    alias :artists :artist

    def song
      Nestling::Song.new(self)
    end

    alias :songs :song

    def track
      Nestling::Track.new(self)
    end

    def playlist
      Nestling::Playlist.new(self)
    end

    def get(meth, params = {})
      path = "/api/v4/#{meth}?" << convert_params(params)
      response, data = @http.get(path, {'User-Agent' => USER_AGENT})
      hash = JSON.parse(data)

      if (code = hash["response"]["status"]["code"].to_i) != 0
        raise ERRNO[code], hash["response"]["status"]["message"]
      end

      hash
    end

    private

    def convert_params(params)
      params = params.merge!(@default_params)
      params.map do |key, value|
        if value.kind_of?(Array)
          value.map { |val| http_param(key, val) }
        else
          http_param(key, value)
        end
      end.join('&')
    end

    def http_param(key, value)
      "#{key}=#{CGI::escape(value.to_s)}"
    end
  end
end

