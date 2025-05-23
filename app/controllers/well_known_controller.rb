class WellKnownController < ApplicationController
  def openid_configuration
    issuer = ENV["IDP_HOST"]

    render json: {
      issuer: "#{issuer}/",
      authorization_endpoint: "#{issuer}/oauth/authorize",
      token_endpoint: "#{issuer}/oauth/token",
      userinfo_endpoint: "#{issuer}/oauth/userinfo",
      jwks_uri: "#{issuer}/oauth/jwks",
      response_types_supported: [ "code" ],
      subject_types_supported: [ "public" ],
      id_token_signing_alg_values_supported: [ "RS256" ],
      scopes_supported: [ "openid", "email", "profile" ],
      token_endpoint_auth_methods_supported: [ "client_secret_basic" ],
      claims_supported: [ "sub", "email", "name" ]
    }
  end
end
