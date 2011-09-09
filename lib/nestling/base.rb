module Nestling
  class Base
    attr_reader :client

    METHOD_PREFIX = ""
    METHODS       = {}

    def initialize(client)
      @client = client
    end

    def method_missing(meth, *args, &block)
      unless method = self.class::METHODS[meth]
        return super(meth, *args, &block)
      end

      opts  = args[0] || {}
      key   = meth.to_s
      query = self.class::METHOD_PREFIX + key

      resp    = get(query, options(opts))["response"]
      payload = resp[method[:key] || key]

      if method[:collection]
        Collection.new(resp["total"], resp["start"],
                       resp["session_id"]).tap do |c|
          payload.each { |h| c << convert(h) }
        end
      else
        convert(payload)
      end
    end

    private

    def convert(hash)
      hash = Hash.new(hash)

      hash.each do |key, value|
        if value.kind_of?(String) &&
          value.match(/\d{4}(-\d\d){2}T\d{2}(:\d\d){2}/)
          hash[key] = DateTime.parse(value)
        elsif value.kind_of?(::Hash)
          hash[key] = convert(value)
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

