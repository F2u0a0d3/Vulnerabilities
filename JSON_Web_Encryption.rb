require 'jwe'

key = OpenSSL::PKey::RSA.new File.read 'public.pem'

payload = {user:"admin"}.to_json
puts JWE.encrypt(payload, key, enc: 'A192GCM')
