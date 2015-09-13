require 'mobile_number_normalizer'
require 'error_codes'

module SmsSenderSmsgw
  require "net/http"

  include MobileNumberNormalizer
  include ErrorCodes

  # According to documentation: http://smsgw.net/docs/
  def self.send_sms(credentials, mobile_number, message, sender, options = nil)
    recepient_number = MobileNumberNormalizer.normalize_number(mobile_number.dup)
    http = Net::HTTP.new('api.smsgw.net', 80)
    path = '/SendSingleSMS'
    body = "strUserName=#{credentials[:username]}&strPassword=#{credentials[:password]}&strTagName=#{sender}&strRecepientNumber=#{recepient_number}&strMessage=#{message}"
    body.append("&sendDateTime=yyyyMMddHHmm#{options[:date_time].strftime("%Y%m%d%H%M")}") if !options.blank? && options[:date_time] && (options[:date_time].kind_of?(DateTime) || options[:date_time].kind_of?(Time))
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

  def self.get_balance(credentials)
    http = Net::HTTP.new('api.smsgw.net', 80)
    path = '/GetCredit'
    body = "strUserName=#{credentials[:username]}&strPassword=#{credentials[:password]}"
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    response = http.post(path, body, headers)
    if response.code.to_i == 200 
      return { balance: response.body.to_i, code: nil }
    else
      return { error: 'Unknow error', code: response.code.to_i }
    end
  end

  def self.query_message(credentials, message_id)
    # This service does not support message id yet! There should be a message id in response of sending sms, but there isn't.
  end
end
