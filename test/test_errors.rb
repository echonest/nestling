require File.join(File.dirname(__FILE__), 'helper')

class TestErrors < MiniTest::Unit::TestCase
  include Nestling

  def test_error_mapping
    assert_equal UnknownError,           ERRNO[-1]
    assert_equal InvalidAPIKeyError,     ERRNO[1]
    assert_equal AccessDeniedError,      ERRNO[2]
    assert_equal RateLimitExceededError, ERRNO[3]
    assert_equal MissingParameterError,  ERRNO[4]
    assert_equal InvalidParameterError,  ERRNO[5]
  end

  def test_error_superclass
    assert_equal Error.superclass, StandardError
  end

  def test_unknown_error_superclass
    assert_equal UnknownError.superclass, Error
  end

  def test_invalid_api_key_error_superclass
    assert_equal InvalidAPIKeyError.superclass, Error
  end

  def test_access_denied_error_superclass
    assert_equal AccessDeniedError.superclass, Error
  end

  def test_rate_limit_exceeded_error_superclass
    assert_equal RateLimitExceededError.superclass, Error
  end

  def test_missing_parameter_error_superclass
    assert_equal MissingParameterError.superclass, Error
  end

  def test_invalid_parameter_error_superclass
    assert_equal InvalidParameterError.superclass, Error
  end
end

