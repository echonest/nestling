require File.join(File.dirname(__FILE__), 'helper')

class TestErrors < MiniTest::Unit::TestCase
  include Nestling

  def setup
    @sym_options = {
      :results    => 10,
      :start      => 2,
      :session_id => 123,
      :type       => "mood"
    }

    @str_options = {
      "results"    => 10,
      "start"      => 2,
      "session_id" => 123,
      "type"       => "mood"
    }

    @str_options_with_total = {
      "total" => 23
    }

    @sym_options_with_total = {
      :total => 23
    }
  end

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
    assert_equal 10, Collection.new(@str_options).results
    assert_equal 10, Collection.new(@sym_options).results
    assert_equal 23, Collection.new(@str_options_with_total).results
    assert_equal 23, Collection.new(@sym_options_with_total).results
  end

  def test_collection_assigns_start
    assert_equal 2, Collection.new(@str_options).start
    assert_equal 2, Collection.new(@sym_options).start
  end

  def test_collection_assigns_session_id
    assert_equal 123, Collection.new(@str_options).session_id
    assert_equal 123, Collection.new(@sym_options).session_id
  end

  def test_collection_assigns_type
    assert_equal "mood", Collection.new(@str_options).type
    assert_equal "mood", Collection.new(@sym_options).type
  end
end

