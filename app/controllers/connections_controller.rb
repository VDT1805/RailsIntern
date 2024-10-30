class ConnectionsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @app = App.find(params[:app_id])
    @conn = Connection.new
    @cred = @conn.creds.build
    case @app.name
    when "Datadog"
      @cred.datadogs.build
    when "Sendgrid"
      @cred.sendgrids.build
    end
  end

  def create
    abort connection_params.inspect
  end

  private
  def connection_params
    params.require(:connection).permit(
      connection_attributes: [
      :app_id,
      :app_type,
      creds_attributes: [
        :label,
        datadogs_attributes: [ :api_key, :application_key, :subdomain ],
        sendgrids_attributes: [ :api_key, :subuser ]
        ]
      ]
    )
  end
end
