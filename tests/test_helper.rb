ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require_relative '../dummy_app'

module TestHelpers

  def message_levels(response)
    response["log"].map do |message|
      message["level"]
    end
  end

  def error_messages(response)
    response["log"].select do |message|
      message["level"] == "error"
    end
  end

  def error_lines(response)
    error_messages(response).map do |message|
      message["message"]["line"] || message["refs"][0]["sourceLine"].to_s
    end.compact
  end
end