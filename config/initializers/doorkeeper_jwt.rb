Doorkeeper::JWT.configure do
  token_payload do |opts|
    app = Doorkeeper::Application.find(opts[:application_id] || opts[:application].try(:id))

    {
      iss: "http://idp.myapp.local/",
      sub: app.uid,
      aud: "my-service-api",
      iat: Time.current.to_i,
      exp: (Time.current + 15.minutes).to_i,
      scopes: opts[:scopes].to_s
    }
  end

  secret_key Rails.application.secret_key_base
  encryption_method :hs256
end
