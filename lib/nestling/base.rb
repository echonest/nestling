module Nestling
  class Base
    attr_reader :client

    METHOD_PREFIX = ""
    METHODS       = {}

    class << self
      def define_api_methods(methods)
        methods.each do |key, definition|
          if definition[:collection]
            define_api_method_returning_collection(key, definition)
          else
            define_api_method(key, definition)
          end
        end
      end

      private

      def define_api_method_returning_collection(key, definition)
        define_method key do |*args|
          resp = get_request(key, args[0])
          hashes = convert_hashes(resp[definition[:key] || key.to_s])
          Collection.new(resp).push(hashes).flatten!
        end
      end

      def define_api_method(key, definition)
        define_method key do |*args|
          resp = get_request(key, args[0])
          convert_hash(resp[definition[:key] || key.to_s])
        end
      end
    end

    def initialize(client)
      @client = client
    end

    private

    def get_request(key, opts)
      opts ||= {}
      query = self.class::METHOD_PREFIX + key.to_s
      get(query, options(opts))["response"]
    end

    def convert_hashes(hashes)
      hashes.map { |hash| convert_hash(hash) }
    end

    def convert_hash(hash)
      hash = Nestling::Hash.new(hash)

      hash.each do |key, value|
        if value.kind_of?(String) &&
          value.match(/\d{4}(-\d\d){2}T\d{2}(:\d\d){2}/)
          hash[key] = DateTime.parse(value)
        elsif value.kind_of?(::Hash)
          hash[key] = convert_hash(value)
        end
      end
    end

    def options(opts)
      opts
    end

    def get(*args)
      @client.get(*args)
    end
  end
end

