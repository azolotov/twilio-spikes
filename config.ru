require File.dirname(__FILE__) + '/config/boot.rb'

run Rack::URLMap.new({
  "/"    => TwilioApp::Main,
  "/apis"    => TwilioApp::Api,
  "/calls"    => TwilioApp::Call
})
