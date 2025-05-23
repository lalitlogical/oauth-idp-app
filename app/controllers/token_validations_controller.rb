class TokenValidationsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    token = request.headers["Authorization"]&.split(" ")&.last

    if token.blank?
      return render json: { error: "Missing Authorization header" }, status: :unauthorized
    end

    begin
      public_key = Rails.application.config.x.jwt_public_key

      decoded_token = JWT.decode(
        token,
        public_key,
        true, # Verify signature
        {
          algorithm: "RS256",
          iss: "#{ENV["IDP_HOST"]}/",
          verify_iss: true,
          aud: "m2m-client-id",
          verify_aud: true
        }
      )

      payload = decoded_token.first

      render json: {
        message: "Token is valid",
        payload: payload
      }

    rescue JWT::ExpiredSignature
      render json: { error: "Token has expired" }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { error: "Invalid token: #{e.message}" }, status: :unauthorized
    end
  end
end
