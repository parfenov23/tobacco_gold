# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!
Thread.new do
  Api::SmsController.sms_start_ws
end