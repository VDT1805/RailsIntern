class DropboxSyncJob < ApplicationJob
  queue_as :default

  def perform(id, limit, include_removed = false)
    dropbox_credential = Dropbox.find(id)
    credential = Cred.find_by(credable_id: id)
    access_token = DropboxServices::GetTokens.new.get_access_token(dropbox_credential.refresh_token)
    fetch_members_service = DropboxServices::FetchMembers.new
    response = fetch_members_service.fetch_members(access_token: access_token, limit: limit, include_removed: include_removed)
    has_more, cursor = handle_data(response,credential.connection_id)

    while has_more
      response = fetch_members_service.fetch_members_continue(access_token: access_token, cursor: cursor)
      has_more, cursor = handle_data(response,credential.connection_id)
    end
    
  end

  private
    def handle_data(response,connection_id)
        data = JSON.parse(response.body)
        account_attributes = data["members"].map do |acc|
          {
            third_party_id: acc["profile"]["account_id"],
            connection_id: connection_id,
            name: acc["profile"]["name"]["display_name"],
            email: acc["profile"]["email"],
            status: acc["profile"]["status"][".tag"]
          }
        end
        Account.upsert_all(account_attributes)
        return data["has_more"], data["cursor"]
    end
end
