require File.join(File.dirname(__FILE__), 'helper')

class TestTrack < MiniTest::Unit::TestCase
  include Nestling

  METHODS = Track::METHODS

  def setup
    @track = Nestling.new('foo').track
  end

  def test_superclass
    assert_equal Base, Track.superclass
  end

  def test_method_prefix
    assert_equal "track/", Track::METHOD_PREFIX
  end

  def test_number_of_methods
    assert_equal 1, METHODS.length
  end

  def test_profile
    refute METHODS[:profile][:collection]
    assert_equal "track", METHODS[:profile][:key]
    assert @track.respond_to?(:profile)
  end
end

