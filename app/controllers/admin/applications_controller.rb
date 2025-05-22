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
      redirect_to admin_applications_path, notice: "OAuth app created"
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
    @application = Doorkeeper::Application.find(params[:id])
    if @application.update(app_params)
      redirect_to admin_applications_path, notice: "Updated"
    else
      render :edit
    end
  end

  def destroy
    Doorkeeper::Application.find(params[:id]).destroy
    redirect_to admin_applications_path, notice: "Deleted"
  end

  private

  def app_params
    params.require(:doorkeeper_application).permit(:name, :redirect_uri, :scopes, :confidential)
  end
end
