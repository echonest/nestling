require File.join(File.dirname(__FILE__), 'helper')

class TestErrors < MiniTest::Unit::TestCase
  include Nestling

  def test_superclass
    assert_equal Collection.superclass, Array
  end

  def test_collection_default_params
    col = Collection.new
    assert_nil col.results
    assert_nil col.start
    assert_nil col.session_id
  end

  def test_collection_assigns_results
    assert_equal 10, Collection.new(10).results
  end

  def test_collection_assigns_results
    assert_equal 2, Collection.new(10, 2).start
  end

  def test_collection_assigns_session_id
    assert_equal 123, Collection.new(10, 2, 123).session_id
  end
end

