Doorkeeper::JWT.configure do
  token_payload do |opts|
    app = Doorkeeper::Application.find(opts[:application_id] || opts[:application].try(:id))

    payload = {
      iss: "#{ENV['IDP_HOST']}/",
      aud: app.uid,
      iat: Time.current.to_i,
      exp: (Time.current + 15.minutes).to_i,
      scopes: opts[:scopes].to_s
    }

    # Insert User Information which can be later decoded and used.
    if opts[:resource_owner_id].present? && user ||= User.find_by(id: opts[:resource_owner_id])
      payload.merge!({
        email: user.email,
        name: user.name,
        display_name: user.display_name
      })
    end

    payload
  end

  secret_key Rails.application.config.x.jwt_private_key
  encryption_method :rs256
end
