# encoding: utf-8
require 'test_helper'

class SmsSenderSmsgwTest < ActiveSupport::TestCase
  test_messages = [
    SmsSenderSmsgw::MobileNumberNormalizer.normalize_message('This message has been sent from automated test 😎'),
    SmsSenderSmsgw::MobileNumberNormalizer.normalize_message('این پیام از آزمون خودکار فرستاده شده است 😎')
  ]
  # Config webmock for sending messages 
  test_messages.each do |m|
    request_body_header = {:body => {'strUserName' => ENV['username'], 'strPassword' => ENV['password'], 'strTagName' => ENV['tag_name'], 'strRecepientNumber' => SmsSenderSmsgw::MobileNumberNormalizer.normalize_number(ENV['mobile_number']), 'strMessage' => m}, :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}}
    WebMock::API.stub_request(:post, 'api.smsgw.net/SendSingleSMS').
      with(request_body_header).
      to_return(:status => 200, 
        :body => "1", 
        :headers => {'Content-Type' => 'text/html'})
  end
  # Config webmock for query balance 
  WebMock::API.stub_request(:post, 'api.smsgw.net/GetCredit').
    with(:body => {'strUserName' => ENV['username'], 'strPassword' => ENV['password']},
      :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}).
    to_return(:status => 200, 
      :body => "10", 
      :headers => {'Content-Type' => 'text/html'})

  test "complete_cycle" do
    balance_before = SmsSenderSmsgw.get_balance({username: ENV['username'], password: ENV['password']})
    assert_equal balance_before[:error], nil
    test_messages.each do |m|
      send_sms_result = SmsSenderSmsgw.send_sms({username: ENV['username'], password: ENV['password']}, ENV['mobile_number'], m, ENV['tag_name'])
      assert_equal send_sms_result[:message_id], nil
      assert_equal send_sms_result[:error], nil
      # Add query message when feature implemented
    end
    balance_after = SmsSenderSmsgw.get_balance({username: ENV['username'], password: ENV['password']})
    assert_equal balance_after[:error], nil
  end
end
