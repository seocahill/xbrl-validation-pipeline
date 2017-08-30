require 'net/http'
require 'json'

module DummyApp
  class Base

    def request_validation(filename)
      uri = URI("http://arelle:8080/rest/xbrl/validation?file=/ixbrl/#{filename}&media=json")
      begin
        request = Net::HTTP.get(uri)
        JSON.parse(request)
      rescue Exception => e
        e.to_s
      end
    end
  end
end