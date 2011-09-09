module Nestling
  class Song < Base
    METHOD_PREFIX = "song/"

    METHODS = {
      :search   => { :collection => true, :key => "songs" },
      :profile  => { :collection => true, :key => "songs" },
      :identify => { :collection => true, :key => "songs" }
    }
  end
end

