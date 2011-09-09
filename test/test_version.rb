require File.join(File.dirname(__FILE__), 'helper')

class TestVersion < MiniTest::Unit::TestCase
  include Nestling

  def test_major
    assert_instance_of Fixnum, Version::MAJOR
  end

  def test_minor
    assert_instance_of Fixnum, Version::MINOR
  end

  def test_patch
    assert_instance_of Fixnum, Version::PATCH
  end

  def test_string
    assert_equal Version::STRING, [Version::MAJOR,
      Version::MINOR, Version::PATCH].compact.join('.')
  end
end

