class Admin::ApplicationsController < Admin::BaseController
  layout "admin"

  def index
    @applications = Doorkeeper::Application.all
  end

  def new
    @application = Doorkeeper::Application.new
  end

  def create
    @application = Doorkeeper::Application.new(app_params)
    if @application.save
      redirect_to admin_applications_path, notice: "OAuth Application was successfully created."
    else
      render :new
    end
  end

  def show
    @application = Doorkeeper::Application.find(params[:id])
  end

  def edit
    @application = Doorkeeper::Application.find(params[:id])
  end

  def update
    cleaned_params = app_params.dup

    # Don't overwrite secret if left blank
    if cleaned_params[:secret].blank?
      cleaned_params.delete(:secret)
    end

    @application = Doorkeeper::Application.find(params[:id])
    if @application.update(cleaned_params)
      redirect_to admin_applications_path, notice: "OAuth Application was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    Doorkeeper::Application.find(params[:id]).destroy
    redirect_to admin_applications_path, notice: "OAuth Application was successfully deleted."
  end

  private

  def app_params
    params.require(:doorkeeper_application).permit(:name, :uid, :secret, :redirect_uri, :scopes, :confidential)
  end
end
