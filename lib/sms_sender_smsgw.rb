require 'mobile_number_normalizer'
require 'error_codes'

module SmsSenderSmsgw
  require "net/http"

  include MobileNumberNormalizer
  include ErrorCodes

  # According to documentation: http://smsgw.net/docs/
  def self.send_sms(user_name, password, tag_name, recepient_number, message, date_time = nil)
    recepient_number = MobileNumberNormalizer.normalize_number(recepient_number.dup)
    http = Net::HTTP.new('api.smsgw.net', 80)
    path = '/SendSingleSMS'
    body = "strUserName=#{user_name}&strPassword=#{password}&strTagName=#{tag_name}&strRecepientNumber=#{recepient_number}&strMessage=#{message}"
    body.append("&sendDateTime=yyyyMMddHHmm#{date_time.strftime("%Y%m%d%H%M")}") if date_time && (date_time.kind_of?(DateTime) || date_time.kind_of?(Time))
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    response = http.post(path, body, headers)
    if response.code.to_i == 200 && (response.body.to_i == 1 || response.body.to_i == 2)
      return { message_id: nil, code: 1 }
    elsif response.code.to_i == 200
      result = ErrorCodes.get_error_code(response.body.to_i)
      raise result[:error]
      return result
    else
      return { error: 'Unknow error', code: response.code.to_i }
    end
  end

  def self.get_balance(user_name, password)
    http = Net::HTTP.new('api.smsgw.net', 80)
    path = '/GetCredit'
    body = "strUserName=#{user_name}&strPassword=#{password}"
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    response = http.post(path, body, headers)
    if response.code.to_i == 200 
      return { balance: response.body.to_i, code: nil }
    else
      return { error: 'Unknow error', code: response.code.to_i }
    end
  end

  def self.query_message()
    # This service does not support message id yet! There should be a message id in response of sending sms, but there isn't.
  end
end
