class ConnectionsController < ApplicationController
  def index
    @org = Current.user.org
    @connections = @org.connections
  end
  def show
    @conn = Connection.find(params[:id])
    @app = @conn.app
  end
  def new
    @app = App.find(params[:app_id])
    @org = Current.user.org
    @conn = Connection.new
    @cred = @conn.build_cred
    case @app.name
    when "Datadog"
      @cred.build_datadog
    when "Sendgrid"
      @cred.build_sendgrid
    end
  end

  def create
    @app = App.find(params[:app_id])
    @org = Current.user.org
    @conn = Connection.new(connection_params)
    if @conn.save
      redirect_to connection_path(id: @conn.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def connection_params
    params.require(:connection).permit(
      :app_id,
      :org_id,
      cred_attributes: [
        :label,
        datadog_attributes: [ :api_key, :application_key, :subdomain ],
        sendgrid_attributes: [ :api_key, :subuser ]
        ]
    )
  end
end
