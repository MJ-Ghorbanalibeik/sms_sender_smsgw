require 'test_helper'

class SmsSenderSmsgwTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, SmsSenderSmsgw
  end

  test "complete_cycle" do
    balance_before = SmsSenderSmsgw.get_balance({username: ENV['user_name'], password: ENV['password']})
    assert_equal balance_before[:error], nil
    send_sms_result = SmsSenderSmsgw.send_sms({username: ENV['user_name'], password: ENV['password']}, ENV['recepient_number'], 'This message has been sent from automated test', ENV['tag_name'])
    assert_equal send_sms_result[:message_id], nil
    assert_equal send_sms_result[:error], nil
    balance_after = SmsSenderSmsgw.get_balance({username: ENV['user_name'], password: ENV['password']})
    assert_equal balance_after[:error], nil
    assert_equal balance_before[:balance], balance_after[:balance] + 1
    # Add query message when feature implemented
  end
end
