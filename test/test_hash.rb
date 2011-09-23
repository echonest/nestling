require File.join(File.dirname(__FILE__), 'helper')

class TestHash < MiniTest::Unit::TestCase
  def setup
    @strings = { 'a' => 1, 'b' => 2 }
    @symbols = { :a  => 1, :b  => 2 }
    @mixed   = { :a  => 1, 'b' => 2 }
    @fixnums = {  0  => 1,  1  => 2 }
    if RUBY_VERSION < '1.9.0'
      @illegal_symbols = { "\0" => 1, "" => 2, [] => 3 }
    else
      @illegal_symbols = { [] => 3 }
    end
  end

  def test_methods
    h = Nestling::Hash.new
    assert_respond_to h, :symbolize_keys
    assert_respond_to h, :symbolize_keys!
    refute_respond_to Nestling::Hash.new, :length
  end

  def test_initialize
    h = Nestling::Hash.new({ :foo => "bar", "bar" => :baz})
    assert_equal "bar", h[:foo]
    assert_equal :baz, h["bar"]
  end

  def test_symbolize_keys
    assert_equal @symbols, Nestling::Hash.new(@symbols).symbolize_keys
    assert_equal @symbols, Nestling::Hash.new(@strings).symbolize_keys
    assert_equal @symbols, Nestling::Hash.new(@mixed).symbolize_keys
  end

  def test_symbolize_keys!
    assert_equal @symbols, Nestling::Hash.new(@symbols).dup.symbolize_keys!
    assert_equal @symbols, Nestling::Hash.new(@strings).dup.symbolize_keys!
    assert_equal @symbols, Nestling::Hash.new(@mixed).dup.symbolize_keys!
  end

  def test_symbolize_keys_preserves_keys_that_cant_be_symbolized
    assert_equal @illegal_symbols,
      Nestling::Hash.new(@illegal_symbols).symbolize_keys
    assert_equal @illegal_symbols,
      Nestling::Hash.new(@illegal_symbols).dup.symbolize_keys!
  end

  def test_symbolize_keys_preserves_fixnum_keys
    assert_equal @fixnums, Nestling::Hash.new(@fixnums).symbolize_keys
    assert_equal @fixnums, Nestling::Hash.new(@fixnums).dup.symbolize_keys!
  end

  def test_method_style_properties_for_symbols
    h = Nestling::Hash.new(:foo => :bar)
    assert_equal h[:foo], h.foo
  end
end

