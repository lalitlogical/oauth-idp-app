class Oauth::JwksController < ApplicationController
  def show
    jwk = JWT::JWK.new(Rails.application.config.x.jwt_public_key)
    render json: { keys: [ jwk.export ] }
  end
end
