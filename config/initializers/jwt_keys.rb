private_key_path = Rails.root.join("config", "keys", "private.pem")
public_key_path  = Rails.root.join("config", "keys", "public.pem")

Rails.application.config.x.jwt_private_key = OpenSSL::PKey::RSA.new(File.read(private_key_path))
Rails.application.config.x.jwt_public_key  = OpenSSL::PKey::RSA.new(File.read(public_key_path))
