module Oauth
  class UserinfoController < ActionController::Base
    before_action :doorkeeper_authorize!

    def show
      user = User.find(doorkeeper_token.resource_owner_id)

      render json: {
        sub: user.id,
        email: user.email,
        name: user.name
      }
    end
  end
end
