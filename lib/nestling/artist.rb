module Nestling
  class Artist < Base
    attr_reader :id, :name

    METHOD_PREFIX = "artist/"

    METHODS = {
      :biographies => { :collection => true },
      :blogs       => { :collection => true },
      :familiarity => { :collection => false, :key => "artist" },
      :hotttnesss  => { :collection => false, :key => "artist" },
      :images      => { :collection => true },
      :list_terms  => { :collection => true },
      :news        => { :collection => true },
      :profile     => { :collection => false, :key => "artist" },
      :reviews     => { :collection => true },
      :search      => { :collection => true, :key => "artists" },
      :extract     => { :collection => true, :key => "artist" },
      :songs       => { :collection => true },
      :similar     => { :collection => true, :key => "artists" },
      :suggest     => { :collection => true, :key => "artists" },
      :terms       => { :collection => true },
      :top_hottt   => { :collection => true, :key => "artists" },
      :top_terms   => { :collection => true, :key => "terms" },
      :urls        => { :collection => false },
      :video       => { :collection => true }
    }

    define_api_methods METHODS

    def initialize(name, client)
      name.kind_of?(::Hash) ? @id = name[:id] : @name = name
      super(client)
    end

    private

    def options(opts)
      id_or_name.merge!(opts)
    end

    def id_or_name
      @id ? { :id => @id } : { :name => @name }
    end
  end
end

