$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installed

# stdlib
require 'net/http'
require 'cgi'
require 'date'

# gems
require 'json'

# internal
require 'nestling/version'
require 'nestling/errors'
require 'nestling/client'

require 'nestling/base'
require 'nestling/artist'
require 'nestling/song'
require 'nestling/track'
require 'nestling/playlist'

require 'nestling/collection'
require 'nestling/hash'

module Nestling
  class << self
    attr_accessor :api_key

    def new(*args)
      Nestling::Client.new(*args[0])
    end
  end
end

