ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require_relative 'dummy_app'
require_relative 'test_helper'

class DimensionParserTest < MiniTest::Test
  include TestHelpers

  def setup 
    @app = DummyApp::Base.new
  end

  def test_valid_file
    response = @app.request_validation("valid-file.html")
    refute_includes message_levels(response), "error", "no invalid messages"
  end
end