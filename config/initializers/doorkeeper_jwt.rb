private_key = OpenSSL::PKey::RSA.generate(2048)

Doorkeeper::JWT.configure do
  token_payload do |opts|
    app = Doorkeeper::Application.find(opts[:application_id] || opts[:application].try(:id))

    {
      iss: "#{ENV['IDP_HOST']}/",
      sub: app.uid,
      iat: Time.current.to_i,
      exp: (Time.current + 15.minutes).to_i,
      scopes: opts[:scopes].to_s
    }
  end

  secret_key private_key
  encryption_method :rs256
end
