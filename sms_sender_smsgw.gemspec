$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sms_sender_smsgw/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sms_sender_smsgw"
  s.version     = SmsSenderSmsgw::VERSION
  s.authors     = ["Mojtaba Ghorbanalibeik", "Hossein Bukhamseen"]
  s.email       = ["mojtaba.ghorbanalibeik@gmail.com", "bukhamseen.h@gmail.com"]
  s.summary     = "Send sms via smsgw.net"
  s.description = "Send sms via smsgw.net"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
end
