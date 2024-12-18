module GoogleWorkspaceServices
  class GetTokens
    include GoogleAuth
    def initialize
      @auth_client = self.class.create_auth_client(
      'https://www.googleapis.com/auth/admin.directory.user.readonly',
      'http://localhost:3000/oauth_callback/GoogleWorkspace',
      {
        "access_type" => "offline",         # offline access
        "include_granted_scopes" => "true" # incremental auth
      }
    )
    end

    def get_refresh_token(auth_code, oauth_callback_url)
        auth_client.code = auth_code
        auth_client.fetch_access_token!
        auth_client.refresh_token
    end

    private
      attr_reader :auth_client
    end
end