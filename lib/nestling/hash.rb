module Nestling
  class Hash < ::Hash
    def initialize(hash = nil, *args)
      self.merge!(hash) if hash
      super *args
    end

    def method_missing(meth, *args, &block)
      (val = self[meth]) ? val : super(meth, *args, &block)
    end

    # Adapted from ActiveSupport (part of Ruby on Rails)
    # Released under the MIT license
    def symbolize_keys
      inject({}) do |options, (key, value)|
        options[(key.to_sym rescue key) || key] = value
        options
      end
    end

    def symbolize_keys!
      self.replace(self.symbolize_keys)
    end
  end
end

