require 'net/http'
require 'json'
require 'logger'

module DummyApp
  class Base

    def init
      @log = Logger.new(File.new(File.join(__dir__, "logs", "error.log")),'w')
    end

    def request_validation(filename)
      uri = URI("http://arelle:8080/rest/xbrl/validation?file=/ixbrl/#{filename}&media=json")
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