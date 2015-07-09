require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class MyTest < MiniTest::Unit::TestCase

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_hello_world
    get '/'
    assert last_response.ok?
    assert_equal "Hello", last_response.body
  end

  def non_websocket_client
    get '/log'
    assert last_response.ok?
    assert_equal "require websocket", last_response.body
  end
end

