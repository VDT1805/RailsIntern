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
    @conn = Connection.new(org: @org, app: @app)
    @conn.build_credable
  end

  def create
    @app = App.find(params[:app_id])
    @org = Current.user.org
    @conn = Connection.new(org: @org, app: @app)
    @conn.build_credable(connection_params)
    if @conn.save
      redirect_to connection_path(id: @conn)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def connection_params
    params.require(:connection).permit(
        cred_attributes: [
          :label,
          credable_attributes: [
            # Add all possible delegated type attributes here
            :api_key, :application_key, :subdomain, # Datadog
            :api_token, :organization_id,          # Sentry
            :refresh_token                        # Dropbox
          ]
        ]
    )
  end
end
