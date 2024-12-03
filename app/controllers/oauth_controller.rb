class OauthController < ApplicationController
  def oauth_callback
      # Exchange auth_code for refresh token and access token
      auth_code = params[:code]
      response = DropboxServices::GetTokens.new.get_refresh_token(auth_code,oauth_callback_url)
      refresh_token = JSON.parse(response.body)["refresh_token"]
      app = App.find_by(name: params[:app_name])
      org = Current.user.org
      @conn = Connection.new(app:app,org:org)
      connection_attributes = {
          cred_attributes:
            {
              label: "",
              credable_attributes:  {
                refresh_token: refresh_token
              }
            }
        }
      @conn.build_credable(connection_attributes)
      @conn.save!
      redirect_to connection_path(@conn)
  end
end 
