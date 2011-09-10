require File.join(File.dirname(__FILE__), 'helper')

class TestPlaylist < MiniTest::Unit::TestCase
  include Nestling

  METHODS = Playlist::METHODS

  def setup
    @playlist = Nestling.new('foo').playlist
  end

  def test_superclass
    assert_equal Base, Playlist.superclass
  end

  def test_method_prefix
    assert_equal "playlist/", Playlist::METHOD_PREFIX
  end

  def test_number_of_methods
    assert_equal 3, METHODS.length
  end

  def test_static
    assert METHODS[:static][:collection]
    assert_equal "songs", METHODS[:static][:key]
    assert @playlist.respond_to?(:static)
  end

  def test_dynamic
    assert METHODS[:dynamic][:collection]
    assert_equal "songs", METHODS[:dynamic][:key]
    assert @playlist.respond_to?(:dynamic)
  end

  def test_session_info
    refute METHODS[:session_info][:collection]
    assert_equal "terms", METHODS[:session_info][:key]
    assert @playlist.respond_to?(:session_info)
  end
end

