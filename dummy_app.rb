require 'net/http'
require 'json'

module DummyApp
  class Base

    def request_validation(filename)
      uri = URI("http://arelle:8080/rest/xbrl/validation?file=/ixbrl/#{filename}&media=json")
      begin
        request = Net::HTTP.get(uri)
        response = JSON.parse(request)
        # puts JSON.pretty_generate(response)
        response
      rescue Exception => e
        e.to_s
      end
    end
  end
end