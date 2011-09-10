require File.join(File.dirname(__FILE__), 'helper')

class BaseTest < Nestling::Base
  METHOD_PREFIX = 'test/'

  METHODS = {
    :omg =>  { :collection => true,  :key => "foo" },
    :bar =>  { :collection => false, :key => "baz" },
    :zomg => { :collection => false }
  }

  define_api_methods METHODS
end

class TestBase < MiniTest::Unit::TestCase
  include Nestling

  def setup
    @collection_response = <<-EOS
      {"response": {
        "status": {
          "version": "4.2",
          "code": 0,
          "message": "Success"
        },
        "start": 11,
        "total": 1393,
        "session_id": 123,
        "foo": [{
          "title": "foo",
          "date": "2011-08-16T01:15:01"
        }]
      }}
    EOS

    @hash_response = <<-EOS
      {"response": {
        "status": {
          "code": "0",
          "message": "Success",
          "version": "4.2"
        },
        "baz": {
          "hotttnesss": 0.61081915371492912,
          "name": "Radiohead"
        }
      }}
    EOS

    @nested_hash_response = <<-EOS
      {"response": {
        "status": {
          "code": "0",
          "message": "Success",
          "version": "4.2"
        },
        "zomg": {
          "sub": {
            "hotttnesss": 0.61081915371492912
          },
          "name": "Radiohead"
        }
      }}
    EOS

    @client = Client.new('foo')
  end

  def test_request
    expect_request @collection_response, 'test/omg'
    BaseTest.new(@client).omg
  end

  def test_passes_options
    expect_request @collection_response, 'test/omg', { :foo => 'bar' }
    BaseTest.new(@client).omg :foo => 'bar'
  end

  def test_define_api_methods
    assert Base.respond_to?(:define_api_methods)
  end

  def test_define_api_methods_defines_instance_methods
    BaseTest::METHODS.each do |method|
      assert BaseTest.method_defined?(:method)
    end
  end

  def test_converts_hash
    stub_http_get @hash_response
    hash = BaseTest.new(@client).bar
    assert_equal 0.61081915371492912, hash.hotttnesss
  end

  def test_converts_nested_hash
    stub_http_get @nested_hash_response
    hash = BaseTest.new(@client).zomg
    assert_instance_of Nestling::Hash, hash
    assert_instance_of Nestling::Hash, hash[:sub]
  end

  def test_converts_collection
    stub_http_get @collection_response
    col = BaseTest.new(@client).omg
    assert_instance_of Collection, col
    assert_equal 1393, col.results
    assert_equal 11, col.start
    assert_equal 123, col.session_id
    rec = col[0]
    assert_equal "foo", rec.title
    assert_instance_of Nestling::Hash, rec
    assert_instance_of DateTime, rec.date
    assert_equal "2011-08-16T01:15:01+00:00", rec.date.to_s
  end
end

