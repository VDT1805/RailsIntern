class ConnectionsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @app = App.find(params[:app_id])
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
    @conn = Connection.new(connection_params)
    if @conn.save
      redirect_to org_connection_path(id: @conn.id)
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
