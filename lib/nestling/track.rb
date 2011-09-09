module Nestling
  class Track < Base
    METHOD_PREFIX = "track/"

    METHODS = {
      :profile  => { :collection => false, :key => "track" },
    }
  end
end

