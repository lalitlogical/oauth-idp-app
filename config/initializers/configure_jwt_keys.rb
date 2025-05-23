private_key_path = Rails.root.join("config", "keys", "private.pem")
public_key_path  = Rails.root.join("config", "keys", "public.pem")

if File.exist?(private_key_path) && File.exist?(public_key_path)
  Rails.application.config.x.jwt_private_key = OpenSSL::PKey::RSA.new(File.read(private_key_path))
  Rails.application.config.x.jwt_public_key  = OpenSSL::PKey::RSA.new(File.read(public_key_path))
else
  Rails.logger.warn "JWT key files missing in config/keys/"
end
