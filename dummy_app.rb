require 'net/http'
require 'json'
require 'logger'

module DummyApp
  class Base

    def initialize
      logfile = File.new(File.join(__dir__, "logs", "error.log"), 'w')
      @log = Logger.new(logfile)
    end

    def arelle_validation(filename)
      uri = URI("http://arelle:8080/rest/xbrl/validation?file=/ixbrl/#{filename}&media=json")
      request_validation(filename, uri)
    end

    def business_validation(filename)
      uri = URI("http://validator:4567/validate/#{filename}")
      request_validation(filename, uri)
    end

    def request_validation(filename, uri)
      begin
        request = Net::HTTP.get(uri)
        response = JSON.parse(request)
        File.open(File.join(__dir__, "logs", filename.gsub("html", "json")), 'w') do |f|
          f.write(JSON.pretty_generate(response))
        end
        response
      rescue Exception => e
        @log.error(e)
      end
    end
  end
end