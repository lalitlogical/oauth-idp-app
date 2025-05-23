class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # For sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :display_name ])

    # For account update
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :display_name ])
  end
end
