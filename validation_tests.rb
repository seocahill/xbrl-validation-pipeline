ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require_relative 'dummy_app'

class DimensionParserTest < MiniTest::Test

  def setup 
    @app = DummyApp::Base.new
  end

  def test_valid_file
    assert_equal @app.request_validation("valid-file.html"), "hello world", "should be good!"
  end
end