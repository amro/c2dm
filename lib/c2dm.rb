require 'httparty'
require 'cgi'

class C2DM
  include HTTParty
  default_timeout 30

  attr_accessor :timeout, :auth_token

  AUTH_URL = 'https://www.google.com/accounts/ClientLogin'
  PUSH_URL = 'http://android.apis.google.com/c2dm/send' # Work around expired/bad SSL cert...

  class << self
    attr_accessor :auth_token

    def authenticate!(username=nil, password=nil, source=nil)
      auth_options = {
        'accountType' => 'HOSTED_OR_GOOGLE',
        'service'     => 'ac2dm',
        'Email'       => username || self.username,
        'Passwd'      => password || self.password,
        'source'      => source   || 'MyCompany-MyAppName-1.0'
      }
      post_body = build_post_body(auth_options)

      params = {
        :body    => post_body,
        :headers => {
          'Content-type'   => 'application/x-www-form-urlencoded',
          'Content-length' => post_body.length.to_s
        }
      }

      response = self.post(AUTH_URL, params)

      # check for authentication failures
      raise response.parsed_response if response['Error=']

      @auth_token = response.body.split("\n")[2].gsub('Auth=', '')
    end

    def send_notifications(notifications = [])
      c2dm = C2DM.new(@auth_token)
      notifications.collect do |notification|
        {
          :body => c2dm.send_notification(notification),
          :registration_id => notification[:registration_id]
        }
      end
    end
    
    def build_post_body(options={})
      post_body = []

      # data attributes need a key in the form of "data.key"...
      data_attributes = options.delete(:data)
      data_attributes.each_pair do |k,v|
        post_body << "data.#{k}=#{CGI::escape(v.to_s)}"
      end if data_attributes

      options.each_pair do |k,v|
        post_body << "#{k}=#{CGI::escape(v.to_s)}"
      end

      post_body.join('&')
    end
    
  end

  def initialize(auth_token = nil)
    @auth_token = auth_token || self.class.auth_token
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
    options[:collapse_key] ||= 'foo'
    post_body = self.class.build_post_body(options)

    params = {
      :body    => post_body,
      :headers => {
        'Authorization'  => "GoogleLogin auth=#{@auth_token}",
        'Content-type'   => 'application/x-www-form-urlencoded',
        'Content-length' => "#{post_body.length}"
      }
    }

    self.class.post(PUSH_URL, params)
  end

end