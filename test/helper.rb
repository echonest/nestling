require File.join(File.dirname(__FILE__), '..', 'lib', 'nestling')

require 'minitest/autorun'
require 'mocha'

def stub_http_get(ret)
  Net::HTTP.any_instance.stubs(:get).returns([{}, ret])
end

def expect_request(resp, req, opts = nil)
  resp = JSON.parse(resp)
  if opts
    Client.any_instance.expects(:get).with(req, opts).returns(resp)
  else
    Client.any_instance.expects(:get).with(req, anything).returns(resp)
  end
end

