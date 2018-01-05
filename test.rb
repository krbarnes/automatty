ENV['RACK_ENV'] = 'test'

require './auto_matty'
require 'test/unit'
require 'rack/test'

class HelloWorldTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_says_hello_world
    get '/'
    assert last_response.ok?
    assert_equal 'Hello World, I\'m Otto Matty', last_response.body
  end

  def test_sample_returns_200
    file = open 'sample_payload.json'
    content = file.read
    file.close

    assert !content.nil?
    post('/fulfilled', content, { 'CONTENT_TYPE' => 'application/json' })
    puts "\n\nRESPONSE: #{last_response.body}"
    assert last_response.ok?
  end

end