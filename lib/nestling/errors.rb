module Nestling
  class Error                  < StandardError ; end
  class UnknownError           < Error ; end
  class InvalidAPIKeyError     < Error ; end
  class AccessDeniedError      < Error ; end
  class RateLimitExceededError < Error ; end
  class MissingParameterError  < Error ; end
  class InvalidParameterError  < Error ; end

  ERRNO = {
   -1 => UnknownError,
    1 => InvalidAPIKeyError,
    2 => AccessDeniedError,
    3 => RateLimitExceededError,
    4 => MissingParameterError,
    5 => InvalidParameterError
  }
end

