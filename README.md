Nestling
========

## DESCRIPTION

Nestling is a Ruby wrapper for the [EchoNest](http://the.echonest.com/)
developer APIs.

Nestling is still under heavy development, but should work as advertised.

## INSTALLATION

The best way to install Nestling is with RubyGems:

    $ [sudo] gem install nestling

If you're installing from source, you can use [Bundler](http://gembundler.com/)
to pick up all the gems:

    $ bundle install # ([more info](http://gembundler.com/bundle_install.html))

## HOW DOES IT WORK?

The Nestling API allows you to use native Ruby syntax to retrieve awesome music
intelligence from EchoNest.

    # Require rubygems (if necessary)
    require 'rubygems'

    # Require Nestling
    require 'nestling'

    # Create a new Nestling client
    Nestling.new("api_key")

You can also set a global API key so you don't have to pass it as a parameter
every time you instantiate a new client:

    Nestling.api_key = "api_key"
    nestling = Nestling.new

Once that's done, fetch some cool data, wrapped into convenient Ruby objects:

    nestling.artist("Radiohead").familiarity
    # => { :familiarity => 0.8876162307328723, :id => "ARH6W4X1187B99274F", :name => "Radiohead" }

All parameters supported by EchoNest can be passed to any method as a Hash.
Multiple values for a parameter can be passed as an Array:

    nestling.song.search :artist => "Radiohead",
                         :title  => "Karma Police",
                         :bucket => [ :song_hotttnesss, :artist_hotttnesss ]
    # => [{
    #       :title             => "Karma Police",
    #       :artist_name       => "Radiohead",
    #       :artist_hotttnesss => 0.7072656285368659,
    #       :song_hotttnesss   => 0.9022637157002812,
    #       :artist_id         => "ARH6W4X1187B99274F",
    #       :id                => "SOHJOLH12A6310DFE5"
    #     }]

Additional information passed by EchoNest for collections (such as `results`,
`start` or `session_id`) are, of course, available.

    blogs = nestling.artist("Radiohead").blogs :start => 100

    blogs.results
    # => 5278

    blogs.start
    # => 100

`Nestling::Collection` and `Nestling::Hash` objects inherit from `Array` and
`Hash`, respectively. Therefore, you can enumerate and do other crazy stuff,
too:

    blogs.each do |blog|
      puts blog.name
    end

Nestling will also convert timestamps to Ruby DateTime objects for you:

    nestling.artist("Radiohead").blogs[0].date_found
    # => #<DateTime: 2011-09-09T20:49:16+00:00 (53045590339/21600,0/1,2299161)>

## WHAT'S MISSING AT THE MOMENT?

- Catalog API Methods
- Identifying songs with POST
- track/analyze
- track/upload

## CONTRIBUTE

If you'd like to contribute to Nestling, start by forking my repo on GitHub:

[http://github.com/tobiassvn/nestling](http://github.com/tobiassvn/nestling)

To get all of the dependencies, install the gem first. The best way to get
your changes merged back into core is as follows:

1. Clone down your fork
1. Create a thoughtfully named topic branch to contain your change
1. Hack away
1. Add tests and make sure everything still passes by running `rake`
1. If you are adding new functionality, document it in the README
1. Do not change the version number, I will do that on my end
1. If necessary, rebase your commits into logical chunks, without errors
1. Push the branch up to GitHub
1. Send a pull request to the tobiassvn/nestling project.

## LICENSE

Copyright (c) 2011 Tobias Svensson. See LICENSE for further details.

