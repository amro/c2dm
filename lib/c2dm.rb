require 'httparty'
require 'cgi'

class C2DM
  include HTTParty
  default_timeout 30

  attr_accessor :timeout, :username, :password, :source, :auth_token

  AUTH_URL = 'https://www.google.com/accounts/ClientLogin'
  PUSH_URL = 'https://android.apis.google.com/c2dm/send'
  DEFAULT_SOURCE = 'MyCompany-MyAppName-1.0'

  def initialize(username=nil, password=nil, source=DEFAULT_SOURCE, auth_token=nil)
    @username   = username
    @password   = password
    @source     = source
    @auth_token = auth_token
  end

  def authenticated?
    !@auth_token.nil?
  end

  def authenticate!(username=nil, password=nil, source=nil)
    auth_options = {
      'accountType' => 'HOSTED_OR_GOOGLE',
      'service'     => 'ac2dm',
      'Email'       => username || self.username,
      'Passwd'      => password || self.password,
      'source'      => source   || self.source
    }
    post_body = build_post_body(auth_options)

    params = {
      :body    => post_body,
      :headers => {
        'Content-type'   => 'application/x-www-form-urlencoded',
        'Content-length' => post_body.length.to_s
      }
    }

    response = self.class.post(AUTH_URL, params)

    # check for authentication failures
    raise response.parsed_response if response['Error=']

    @auth_token = response.body.split("\n")[2].gsub('Auth=', '')
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
    post_body = build_post_body(options)

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

  class << self
    def send_notifications(username=nil, password=nil, notifications=[], source=nil)
      c2dm = C2DM.new(username, password, source)

      notifications.collect do |notification|
        { :body => c2dm.send_notification(notification),
          :registration_id => notification[:registration_id] }
      end
    end
  end

private
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