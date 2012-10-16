require 'sinatra/base'
require 'twilio-ruby'
require 'pry-remote'
require 'rack-flash'

module TwilioApp
  class TwilioBase < Sinatra::Base
    set :static, true
    enable :sessions
    use Rack::Flash
  end

  class Main < TwilioBase
    set :views, File.join(File.dirname(__FILE__),'views','main')

    get '/' do
      erb :index
    end
  end

  class Call < TwilioBase
    set :views, File.join(File.dirname(__FILE__),'views','call')
    set :session_secret, "something"

    get '/' do
      erb :index
    end

    post '/user' do
      @account_sid = ENV['TWILIO_ID']
      @auth_token = ENV['TWILIO_TOKEN']

      @client = Twilio::REST::Client.new(@account_sid, @auth_token)
      @account = @client.account

      if params[:number].empty?
        flash[:error] = "You have to write a phone number"
      else
        @call = @account.calls.create({
          :from => '+48128810874',
          :to => params[:number],
          :url => 'http://3w6m.localtunnel.com/call/hello.xml'
        })

        flash[:notice] = "Status: #{@call.status}"
      end
      redirect '/call'
    end

    post '/hello.xml' do
      content_type 'text/xml'
      response = Twilio::TwiML::Response.new do |r|
        r.Say 'Hello Anton Man!', :voice => 'man'
      end
      erb response.text
    end
  end
end
