require 'httparty'
require 'json'

class C2DM
  include HTTParty
  format :plain
  default_timeout 10

  attr_accessor :timeout, :api_key

  GCMError = Class.new(StandardError)
  API_ENDPOINT = 'https://android.googleapis.com/gcm/send'

  class << self
    attr_accessor :api_key

    # send_notifications([
    #   {registration_id: "aRegId1", data: {some_message: "hello", a_value: 5}, collapse_key: "optional_collapse_key"},
    #   {registration_id: "aRegId2", data: {some_message: "weeee", a_value: 1}},
    #   ...
    # ])
    def send_notifications(notifications = [])
      c2dm = C2DM.new(@api_key)
      notifications.collect do |notification|
        response = nil

        begin
          response = c2dm.send_notification(notification[:registration_id], notification[:data], notification[:collapse_key])
        rescue GCMError => e
          response = e
        end
        
        {
          "registration_id" => notification[:registration_id],
          "response" => response
        }
      end
    end
  end

  def initialize(api_key = nil)
    @api_key = api_key || self.class.api_key
  end

  # send_notification("aRegId...", {some_message: "hello", a_value: 5}, "optional collapse_key")
  def send_notification(registration_id, data, collapse_key = nil)
    raise GCMError.new("registration_id must be a String") unless registration_id.is_a?(String)
    
    payload = {
      registration_ids: [registration_id],
      data: data, 
      collapse_key: collapse_key
    }

    parse_response(send(payload))
  end
  
  private
  def send(payload)
    self.class.post(API_ENDPOINT, body: payload.to_json, headers: request_headers)
  end
  
  def request_headers
    {
      "Authorization" => "key=#{@api_key}",
      "Content-Type" => "application/json"
    }
  end
  
  def parse_response(response)
    begin
      parsed_response = JSON.parse(response.body)
      
      if (parsed_response["results"].first["error"])
        raise GCMError.new(parsed_response["results"].first["error"])
      end
      
      parsed_response
    rescue JSON::ParserError
      raise GCMError.new(response.body)
    end
  end
end
