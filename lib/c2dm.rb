require 'httparty'
require 'cgi'

class C2DM
  include HTTParty
  default_timeout 30

  attr_accessor :timeout

  AUTH_URL = 'https://www.google.com/accounts/ClientLogin'
  PUSH_URL = 'https://android.apis.google.com/c2dm/send'
  DEFAULT_SOURCE = 'MyCompany-MyAppName-1.0'

  def initialize(username, password, source = DEFAULT_SOURCE)
    auth(username, password, source)
  end

  def auth(username, password, source)
    post_body = "accountType=HOSTED_OR_GOOGLE&Email=#{username}&Passwd=#{password}&service=ac2dm&source=#{source}"
    params = {
      :body => post_body, 
      :headers => {
        'Content-type' => 'application/x-www-form-urlencoded', 
        'Content-length' => "#{post_body.length}"
      }
    }

    response = self.class.post(AUTH_URL, params)

    raise response if response["Error="] #Raise error in case of auth failure

    response_split = response.body.split("\n")
    @auth_token = response_split[2].gsub("Auth=", "")
  end

  # {
  #   :registration_id => "...",
  #   :data => {
  #     :some_message => "Hi!", 
  #     :another_message => 7
  #   }
  #   :collapse_key => "optional collapse_key string"
  # }
  def send_notification(options)
    post_body = []
    options.delete(:data).each_pair do |k,v| 
      post_body << "data.#{k}=#{CGI::escape(v.to_s)}"
    end

    options[:collapse_key] = "foo" unless options[:collapse_key]

    options.each_pair do |k,v| 
      post_body << "#{k}=#{CGI::escape(v.to_s)}"
    end

    post_body = post_body.join("&")
    params = {
      :body => post_body, 
      :headers => {
        'Authorization' => "GoogleLogin auth=#{@auth_token}",
        'Content-type' => 'application/x-www-form-urlencoded',
        'Content-length' => "#{post_body.length}"
      }
    }
    self.class.post(PUSH_URL, params)
  end

  def self.send_notifications(username, password, notifications, source = DEFAULT_SOURCE)
    c2dm = C2DM.new(username, password, source)
    responses = []
    notifications.each do |notification|
      responses << {:body => c2dm.send_notification(notification), :registration_id => notification[:registration_id]}
    end
    responses
  end
end