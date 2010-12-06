require 'httparty'
require 'cgi'

module C2DM
  class Push
    include HTTParty
    default_timeout 30

    attr_accessor :timeout

    AUTH_URL = 'https://www.google.com/accounts/ClientLogin'
    PUSH_URL = 'https://android.apis.google.com/c2dm/send'

    def initialize(username, password, source)
      post_body = "accountType=HOSTED_OR_GOOGLE&Email=#{username}&Passwd=#{password}&service=ac2dm&source=#{source}"
      params = {:body => post_body,
                :headers => {'Content-type' => 'application/x-www-form-urlencoded', 
                             'Content-length' => "#{post_body.length}"}}

      response = Push.post(AUTH_URL, params)
      response_split = response.body.split("\n")
      @auth_token = response_split[2].gsub("Auth=", "")
    end

    def send_notification(registration_id, message)
      post_body = "registration_id=#{registration_id}&collapse_key=foobar&data.message=#{CGI::escape(message)}"
      params = {:body => post_body,
                :headers => {'Authorization' => "GoogleLogin auth=#{@auth_token}"}}

      response = Push.post(PUSH_URL, params)
      response
    end

    def self.send_notifications(username, password, source, notifications)
      c2dm = Push.new(username, password, source)
    
      responses = []
      notifications.each do |notification|
        responses << {:body => c2dm.send_notification(notification[:registration_id], notification[:message]), :registration_id => notification[:registration_id]}
      end
      responses
    end

  end
end