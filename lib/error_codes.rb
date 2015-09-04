module ErrorCodes
  def self.get_error_code(error_code)
    # Based on http://smsgw.net/docs/#GetCodeDescription
    case error_code
      when "0"
        {error: "Failed", code: 0}
      when "10"
        {error: "Invalid UserName and Password", code: 10}
      when "20"
        {error: "Invalid TagName Format", code: 20}
      when "30"
        {error: "TagName doesn't exist", code: 30}
      when "40"
        {error: "Insufficient Fund", code: 40}
      when "50"
        {error: "strRecepientNumber Length does not equal to ReplacementList Length", code: 50}
      when "60"
        {error: "Invalid Mobile Number", code: 60}
      when "70"
        {error: "System Error", code: 70}
      else 
        {error: "Unknown error code", code: error_code}
    end
  end
end
