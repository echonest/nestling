module Nestling
  class Collection < Array
    attr_accessor :results, :start, :session_id

    def initialize(results = nil, start = nil, session_id = nil, *args)
      @results    = results
      @start      = start
      @session_id = session_id
      super *args
    end
  end
end

