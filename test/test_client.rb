require File.join(File.dirname(__FILE__), 'helper')

class TestClient < MiniTest::Unit::TestCase
  include Nestling

  def test_echonest
    assert_equal Client::HOST, 'developer.echonest.com'
  end

  def test_user_agent
    assert_equal Client::USER_AGENT, 'Nestling/' << Version::STRING
  end

  def test_default_params_format
    assert_equal Client::DEFAULT_PARAMS[:format], 'json'
  end

  def test_api_key_accessor
    assert_equal Client.new('foo').api_key, 'foo'
  end

  def test_default_api_key
    Nestling.api_key = nil # sanity
    Nestling.api_key = 'bar'
    assert_equal Client.new.api_key, 'bar'
  end

  def test_default_api_key_through_namespace_module
    Nestling.api_key = nil # sanity
    Nestling.api_key = 'baz'
    assert_equal Nestling.new.api_key, 'baz'
  end

  def test_artist_returns_artist_object
    assert_instance_of Artist, Client.new('foo').artist('bar')
  end

  def test_artists_returns_artist_object
    assert_instance_of Artist, Client.new('foo').artists('bar')
  end

  def test_song_returns_song_object
    assert_instance_of Song, Client.new('foo').song
  end

  def test_songs_returns_song_object
    assert_instance_of Song, Client.new('foo').songs
  end

  def test_track_returns_track_object
    assert_instance_of Track, Client.new('foo').track
  end

  def test_playlist_returns_playlist_object
    assert_instance_of Playlist, Client.new('foo').playlist
  end

  def test_request_returns_hash
    response = <<-EOS
      {
        "response": {
          "status": {
            "version": "4.2",
            "code": 0,
            "message": "Success."
          }
        }
      }
    EOS
    stub_http_get response
    assert_equal JSON.parse(response), Client.new('foo').get('bar')
  end

  def test_sends_user_agent
    Net::HTTP.any_instance.expects(:get)
      .with(anything, { 'User-Agent' => Client::USER_AGENT} )
      .returns([{}, <<-EOS
      {
        "response": {
          "status": {
            "version": "4.2",
            "code": 0,
            "message": "Success."
          }
        }
      }
      EOS
      ])
    Client.new('foo').get('bar')
  end

  def test_raises_unknown_error
    stub_http_get <<-EOS
      {
        "response": {
          "status": {
            "version": "4.2",
            "code": -1,
            "message": "foobar"
          }
        }
      }
    EOS
    assert_raises UnknownError, "foobar" do
      Client.new('foo').get('bar')
    end
  end

  def test_raises_invalid_api_key_error
    stub_http_get <<-EOS
      {
        "response": {
          "status": {
            "version": "4.2",
            "code": 1,
            "message": "foobar"
          }
        }
      }
    EOS
    assert_raises InvalidAPIKeyError, "foobar" do
      Client.new('foo').get('bar')
    end
  end

  def test_raises_access_denied_error
    stub_http_get <<-EOS
      {
        "response": {
          "status": {
            "version": "4.2",
            "code": 2,
            "message": "foobar"
          }
        }
      }
    EOS
    assert_raises AccessDeniedError, "foobar" do
      Client.new('foo').get('bar')
    end
  end

  def test_raises_rate_limit_exceeded_error
    stub_http_get <<-EOS
      {
        "response": {
          "status": {
            "version": "4.2",
            "code": 3,
            "message": "foobar"
          }
        }
      }
    EOS
    assert_raises RateLimitExceededError, "foobar" do
      Client.new('foo').get('bar')
    end
  end

  def test_raises_missing_parameter_error
    stub_http_get <<-EOS
      {
        "response": {
          "status": {
            "version": "4.2",
            "code": 4,
            "message": "foobar"
          }
        }
      }
    EOS
    assert_raises MissingParameterError, "foobar" do
      Client.new('foo').get('bar')
    end
  end

  def test_raises_invalid_parameter_error
    stub_http_get <<-EOS
      {
        "response": {
          "status": {
            "version": "4.2",
            "code": 5,
            "message": "foobar"
          }
        }
      }
    EOS
    assert_raises InvalidParameterError, "foobar" do
      Client.new('foo').get('bar')
    end
  end

  # Testing private API is so sexy
  def test_convert_param
    assert_includes Client.new('baz').send(:convert_params, { :foo => "bar" }), "foo=bar"
    assert_includes Client.new('baz').send(:convert_params,{ :foo => "bar baz" }), "foo=bar+baz"
  end

  def test_convert_multiple_params
    assert_includes Client.new('baz').send(:convert_params, { :foo => %w(bar baz) }), "foo=bar&foo=baz"
  end
end

