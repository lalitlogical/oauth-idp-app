Doorkeeper::JWT.configure do
  token_payload do |opts|
    app = Doorkeeper::Application.find(opts[:application_id] || opts[:application].try(:id))

    {
      iss: "#{ENV['IDP_HOST']}/",
      aud: app.uid,
      iat: Time.current.to_i,
      exp: (Time.current + 15.minutes).to_i,
      scopes: opts[:scopes].to_s
    }
  end

  secret_key Rails.application.config.x.jwt_private_key
  encryption_method :rs256
end
